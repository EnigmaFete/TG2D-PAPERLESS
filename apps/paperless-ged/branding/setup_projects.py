import sys
from django.contrib.auth.models import User
from documents.models import (
    Tag, DocumentType, Correspondent, StoragePath, CustomField,
    Workflow, WorkflowTrigger, WorkflowAction,
    SavedView, SavedViewFilterRule, UiSettings
)

def setup_projects():
    print("=== CONFIGURING BOUSKOURA & DAR BOUAZZA MULTI-PROJECT SYSTEM ===")

    # 1. Tags for Projects
    tag_bouskoura, _ = Tag.objects.get_or_create(
        name="PROJET : BOUSKOURA",
        defaults={
            "color": "#02c5f1",
            "matching_algorithm": 1, # Any word
            "match": "bouskoura",
            "is_insensitive": True
        }
    )
    tag_dar_bouazza, _ = Tag.objects.get_or_create(
        name="PROJET : DAR BOUAZZA",
        defaults={
            "color": "#10b981",
            "matching_algorithm": 1,
            "match": "dar bouazza,darbouazza",
            "is_insensitive": True
        }
    )
    print(f"Tags configured: '{tag_bouskoura.name}' and '{tag_dar_bouazza.name}'")

    # 2. Custom Field 'Projet'
    cf_projet, _ = CustomField.objects.get_or_create(
        name="Projet",
        defaults={
            "data_type": "select",
            "extra_data": {"select_options": ["Bouskoura", "Dar Bouazza"]}
        }
    )
    # Ensure options are updated
    cf_projet.extra_data = {"select_options": ["Bouskoura", "Dar Bouazza"]}
    cf_projet.save()
    print(f"Custom Field configured: '{cf_projet.name}' with choices {cf_projet.extra_data['select_options']}")

    # 3. Storage Paths (Physical Disk Folders)
    sp_bouskoura, _ = StoragePath.objects.get_or_create(
        name="Projet Bouskoura",
        defaults={
            "path": "Bouskoura/{{ correspondent }}/{{ document_type }}/{{ created_year }}_{{ title }}",
            "matching_algorithm": 0
        }
    )
    sp_dar_bouazza, _ = StoragePath.objects.get_or_create(
        name="Projet Dar Bouazza",
        defaults={
            "path": "Dar Bouazza/{{ correspondent }}/{{ document_type }}/{{ created_year }}_{{ title }}",
            "matching_algorithm": 0
        }
    )
    print(f"Storage Paths configured: '{sp_bouskoura.name}' and '{sp_dar_bouazza.name}'")

    # 4. Ingestion & Routing Workflows
    # Bouskoura Workflow
    wf_bouskoura, created_wf1 = Workflow.objects.get_or_create(
        name="Routage: Projet Bouskoura",
        defaults={"order": 5, "enabled": True}
    )
    if created_wf1:
        trig1 = WorkflowTrigger.objects.create(
            type=2, # Document Added
            match="bouskoura",
            matching_algorithm=1, # Any word
            is_insensitive=True
        )
        wf_bouskoura.triggers.add(trig1)
        act1 = WorkflowAction.objects.create(
            type=1, # Assignment
            order=1,
            assign_storage_path=sp_bouskoura,
            assign_custom_fields_values={str(cf_projet.id): "Bouskoura"}
        )
        act1.assign_tags.add(tag_bouskoura)
        act1.assign_custom_fields.add(cf_projet)
        wf_bouskoura.actions.add(act1)
        print("Created workflow 'Routage: Projet Bouskoura'")

    # Dar Bouazza Workflow
    wf_dar_bouazza, created_wf2 = Workflow.objects.get_or_create(
        name="Routage: Projet Dar Bouazza",
        defaults={"order": 5, "enabled": True}
    )
    if created_wf2:
        trig2 = WorkflowTrigger.objects.create(
            type=2, # Document Added
            match="dar bouazza,darbouazza",
            matching_algorithm=1, # Any word
            is_insensitive=True
        )
        wf_dar_bouazza.triggers.add(trig2)
        act2 = WorkflowAction.objects.create(
            type=1, # Assignment
            order=1,
            assign_storage_path=sp_dar_bouazza,
            assign_custom_fields_values={str(cf_projet.id): "Dar Bouazza"}
        )
        act2.assign_tags.add(tag_dar_bouazza)
        act2.assign_custom_fields.add(cf_projet)
        wf_dar_bouazza.actions.add(act2)
        print("Created workflow 'Routage: Projet Dar Bouazza'")

    # Also route documents from the 67 Bouskoura suppliers automatically to Bouskoura project!
    wf_supp_bouskoura, created_wf3 = Workflow.objects.get_or_create(
        name="Routage Fournisseurs: Projet Bouskoura",
        defaults={"order": 6, "enabled": True}
    )
    if created_wf3:
        all_suppliers = list(Correspondent.objects.all())
        trig3 = WorkflowTrigger.objects.create(
            type=2, # Document Added
            matching_algorithm=0
        )
        trig3.filter_has_any_correspondents.set(all_suppliers)
        wf_supp_bouskoura.triggers.add(trig3)
        act3 = WorkflowAction.objects.create(
            type=1,
            order=1,
            assign_storage_path=sp_bouskoura,
            assign_custom_fields_values={str(cf_projet.id): "Bouskoura"}
        )
        act3.assign_tags.add(tag_bouskoura)
        act3.assign_custom_fields.add(cf_projet)
        wf_supp_bouskoura.actions.add(act3)
        print(f"Created workflow linking all {len(all_suppliers)} suppliers to Bouskoura project")

    # 5. Fetch Key Document Types
    dt_facture = DocumentType.objects.filter(name="Facture fournisseur").first()
    dt_devis = DocumentType.objects.filter(name="Devis fournisseur").first()
    dt_bc = DocumentType.objects.filter(name="Bon de commande").first()
    dt_bl = DocumentType.objects.filter(name="Bon de livraison").first()
    dt_tech = DocumentType.objects.filter(name="Document technique").first()

    # 6. Create Dedicated Project Saved Views for Dashboard & Sidebar
    project_views_def = [
        # BOUSKOURA HUBS
        {
            "name": "🏗️ BOUSKOURA — Tous les documents",
            "tag": tag_bouskoura,
            "dt_id": None,
            "dt_in": None,
        },
        {
            "name": "📄 BOUSKOURA — Factures",
            "tag": tag_bouskoura,
            "dt_id": dt_facture.id if dt_facture else None,
            "dt_in": None,
        },
        {
            "name": "📦 BOUSKOURA — Commandes & Livraisons",
            "tag": tag_bouskoura,
            "dt_id": None,
            "dt_in": f"{dt_bc.id},{dt_bl.id}" if dt_bc and dt_bl else None,
        },
        {
            "name": "📐 BOUSKOURA — Plans & Technique",
            "tag": tag_bouskoura,
            "dt_id": dt_tech.id if dt_tech else None,
            "dt_in": None,
        },
        # DAR BOUAZZA HUBS
        {
            "name": "🌊 DAR BOUAZZA — Tous les documents",
            "tag": tag_dar_bouazza,
            "dt_id": None,
            "dt_in": None,
        },
        {
            "name": "📄 DAR BOUAZZA — Factures",
            "tag": tag_dar_bouazza,
            "dt_id": dt_facture.id if dt_facture else None,
            "dt_in": None,
        },
        {
            "name": "📦 DAR BOUAZZA — Commandes & Livraisons",
            "tag": tag_dar_bouazza,
            "dt_id": None,
            "dt_in": f"{dt_bc.id},{dt_bl.id}" if dt_bc and dt_bl else None,
        },
        {
            "name": "📐 DAR BOUAZZA — Plans & Technique",
            "tag": tag_dar_bouazza,
            "dt_id": dt_tech.id if dt_tech else None,
            "dt_in": None,
        },
    ]

    project_view_ids = []
    for pvd in project_views_def:
        sv, created = SavedView.objects.get_or_create(
            name=pvd["name"],
            defaults={
                "owner": None,
                "sort_field": "created",
                "sort_reverse": True,
                "page_size": 25,
                "display_mode": "table"
            }
        )
        # Clear old rules on this view and set fresh ones
        sv.filter_rules.all().delete()
        # Rule 1: Project Tag
        SavedViewFilterRule.objects.create(
            saved_view=sv,
            rule_type=6, # has tag
            value=str(pvd["tag"].id)
        )
        # Rule 2: Doc Type if specified
        if pvd["dt_id"]:
            SavedViewFilterRule.objects.create(
                saved_view=sv,
                rule_type=4, # document type is
                value=str(pvd["dt_id"])
            )
        elif pvd["dt_in"]:
            SavedViewFilterRule.objects.create(
                saved_view=sv,
                rule_type=28, # has document type in
                value=str(pvd["dt_in"])
            )
        project_view_ids.append(sv.id)
        print(f"Created/Updated SavedView: '{sv.name}' (ID: {sv.id})")

    # Also keep supplier views accessible in sidebar
    supplier_view_ids = list(
        SavedView.objects.exclude(id__in=project_view_ids)
        .order_by("name")
        .values_list("id", flat=True)
    )

    # 7. Update UiSettings for All Users so the Dashboard & Sidebar show the Project Hubs at the top
    for user in User.objects.all():
        ui, _ = UiSettings.objects.get_or_create(
            user=user,
            defaults={"settings": {}}
        )
        settings = dict(ui.settings) if isinstance(ui.settings, dict) else {}
        sv_settings = dict(settings.get("saved_views", {})) if isinstance(settings.get("saved_views"), dict) else {}

        # Dashboard: Project Hubs are prominently featured first
        sv_settings["dashboard_views_visible_ids"] = project_view_ids
        sv_settings["dashboard_views_sort_order"] = project_view_ids

        # Sidebar: Project Hubs first, followed by supplier quick-access views
        sv_settings["sidebar_views_visible_ids"] = project_view_ids + supplier_view_ids

        settings["saved_views"] = sv_settings
        ui.settings = settings
        ui.save()
        print(f"Updated Dashboard and Sidebar for user: '{user.username}'")

    print("\n=== BOUSKOURA & DAR BOUAZZA MULTI-PROJECT CONFIGURATION COMPLETE ===")

if __name__ == "__main__":
    setup_projects()
