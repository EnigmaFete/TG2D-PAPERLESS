import sys
from documents.models import Correspondent, Tag, DocumentType, Workflow, WorkflowTrigger, WorkflowAction

# --- 1. Normalized Activity Tags (51 items) ---
ACTIVITY_TAGS = [
    "AGRÉGATS", "CIMENT", "BÉTON", "GROS ŒUVRE ET MATÉRIAUX", "PROJECTION ET ENDUITS",
    "BA13 ET FAUX PLAFONDS", "LISSAGE DE BÉTON", "CARRELAGE", "ÉTANCHÉITÉ", "FORMES DE PENTE",
    "FER À BÉTON", "PEINTURE", "MÉTALLERIE", "GARDE-CORPS", "GRILLES ET REGARDS",
    "TAMPONS ET CANIVEAUX", "FOURNITURES DE MAGASIN", "MATÉRIEL ÉLECTRIQUE", "CFO — COURANT FORT",
    "CFA — COURANT FAIBLE", "ÉCLAIRAGE LED ET PANNEAUX", "TOPOGRAPHIE", "LABORATOIRE", "BITUME",
    "PAVÉS ET BORDURES", "CUVELAGE", "LOCATION D'ENGINS", "LOCATION DE NACELLES", "MARBRE",
    "PLOMBERIE PVC", "POMPES", "POTEAUX D'INCENDIE", "MENUISERIE BOIS", "MENUISERIE MÉTALLIQUE",
    "MENUISERIE ALUMINIUM", "PORTES AUTOMATIQUES ET SECTIONNELLES", "PANNEAUX SANDWICH",
    "TÔLES GALVANISÉES", "RÉSINE", "ESPACES VERTS", "CARBURANT", "TRANSPORT",
    "RÉPARATION ET ENTRETIEN DES ENGINS", "SKYDOME", "HABILLAGE", "CITERNE D'EAU", "CLIMATISATION",
    "GNA — À QUALIFIER", "BUS 800 — À QUALIFIER", "ST TRAVAUX 2 — À QUALIFIER", "DIVERS — À QUALIFIER"
]

# --- 2. Document Types (9 items) ---
DOCUMENT_TYPES = [
    ("Facture fournisseur", "facture,invoice,fac-"),
    ("Devis fournisseur", "devis,quotation,offre de prix"),
    ("Bon de commande", "bon de commande,purchase order,bcdc,order"),
    ("Bon de livraison", "bon de livraison,delivery note,bordereau de livraison,bl"),
    ("Contrat fournisseur", "contrat,accord-cadre,convention"),
    ("Bon d'intervention", "bon d'intervention,rapport d'intervention,fiche d'intervention"),
    ("Attestation ou certificat", "attestation,certificat,police d'assurance"),
    ("Document technique", "fiche technique,plan d'exécution,spécification"),
    ("Autre document fournisseur", "")
]

# --- 3. Supplier Register (68 rows -> 67 distinct entities) ---
SUPPLIER_ROWS = [
    ("001", "OULD BOUAZZA", "Agrégats-ciment", ["AGRÉGATS", "CIMENT"]),
    ("002", "OULIFI", "Taloche, projeté, BA13", ["PROJECTION ET ENDUITS", "BA13 ET FAUX PLAFONDS"]),
    ("003", "OUVERDAL", "Lissage de béton", ["LISSAGE DE BÉTON", "BÉTON"]),
    ("004", "FLOORDESIGN", "Carrelage", ["CARRELAGE"]),
    ("005", "COMARBOIS", "Étanchéité", ["ÉTANCHÉITÉ"]),
    ("006", "ACO", "Tampon, grille, caniveaux, rehausse, step", ["TAMPONS ET CANIVEAUX", "GRILLES ET REGARDS"]),
    ("007", "DANIA TRADING", "GNA", ["GNA — À QUALIFIER", "GROS ŒUVRE ET MATÉRIAUX"]),
    ("008", "RAOUAH", "Pose étanchéité, pose de forme de pente, pose de carrelage", ["ÉTANCHÉITÉ", "FORMES DE PENTE", "CARRELAGE"]),
    ("009", "DEJLA FER", "Fer à béton", ["FER À BÉTON"]),
    ("010", "KENIVIT", "Travaux de peinture", ["PEINTURE"]),
    ("011", "MENTARUIS", "Portes métalliques, garde-corps métalliques, grilles métalliques, regards métalliques", ["MÉTALLERIE", "GARDE-CORPS", "GRILLES ET REGARDS"]),
    ("012", "SOFA", "Matériel électrique", ["MATÉRIEL ÉLECTRIQUE"]),
    ("013", "ECOTRA", "Fournitures de magasin", ["FOURNITURES DE MAGASIN"]),
    ("014", "ERRAKI", "Travaux topographiques", ["TOPOGRAPHIE"]),
    ("015", "SMIPSUM", "Portes métalliques, garde-corps métalliques, grilles métalliques, regards métalliques", ["MÉTALLERIE", "GARDE-CORPS", "GRILLES ET REGARDS"]),
    ("016", "GTR", "Travaux de bitume", ["BITUME"]),
    ("017", "ENTREPRISE RAOUAH", "Travaux de carrelage et étanchéité", ["CARRELAGE", "ÉTANCHÉITÉ"]),
    ("018", "RADSHIPP TRANS", "Agrégats", ["AGRÉGATS", "TRANSPORT"]),
    ("019", "SOMALAK", "Travaux de pavé et cuvelage", ["PAVÉS ET BORDURES", "CUVELAGE"]),
    ("020", "NADI CONCEPT", "Location de Poclain", ["LOCATION D'ENGINS"]),
    ("021", "ANDALOUSSIA MARBRE", "Fourniture de marbre", ["MARBRE"]),
    ("022", "PLASTIMA", "Fourniture de plomberie PVC", ["PLOMBERIE PVC"]),
    ("023", "ARTISAN TIMBER", "Menuiserie bois et faux cadre", ["MENUISERIE BOIS"]),
    ("024", "DOHA CERAM", "Fourniture de carrelage", ["CARRELAGE"]),
    ("025", "PREFA", "Fourniture BUS 800", ["BUS 800 — À QUALIFIER", "GROS ŒUVRE ET MATÉRIAUX"]),
    ("026", "ACHRAF CLIM", "ST travaux 2, plomberie et climatisation", ["ST TRAVAUX 2 — À QUALIFIER", "PLOMBERIE PVC", "CLIMATISATION"]),
    ("027", "ABRAR", "Agrégats", ["AGRÉGATS"]),
    ("028", "TAJNA", "Location de Poclain", ["LOCATION D'ENGINS"]),
    ("029", "MAFODER", "Grilles", ["GRILLES ET REGARDS"]),
    ("030", "SANIAJ", "Fourniture PVC et poteaux d'incendie", ["PLOMBERIE PVC", "POTEAUX D'INCENDIE"]),
    ("031", "UNTIRAMAS", "Location de Poclain", ["LOCATION D'ENGINS"]),
    ("032", "INARA DISRIBUTION", "Fourniture LED et panneaux", ["ÉCLAIRAGE LED ET PANNEAUX", "MATÉRIEL ÉLECTRIQUE"]),
    ("033", "WORK MODERN PRO", "Travaux de peinture", ["PEINTURE"]),
    ("034", "LAFARGE", "Béton", ["BÉTON"]),
    ("035", "LAFARGE", "Fourniture de colle", ["GROS ŒUVRE ET MATÉRIAUX"]),
    ("036", "SBBC", "Fourniture de briques rouges", ["GROS ŒUVRE ET MATÉRIAUX"]),
    ("037", "BECOMAR", "Fourniture d'agglos", ["GROS ŒUVRE ET MATÉRIAUX"]),
    ("038", "BRICOMA", "Fournitures de magasin", ["FOURNITURES DE MAGASIN"]),
    ("039", "TUBI CARREAUX", "Fourniture de carrelage", ["CARRELAGE"]),
    ("040", "TRAFTRAFRIC", "Réparation et entretien des engins", ["RÉPARATION ET ENTRETIEN DES ENGINS"]),
    ("041", "INTERFER", "Fourniture de panneaux sandwich", ["PANNEAUX SANDWICH"]),
    ("042", "SOMACHAME", "Fourniture de tôles galvanisées", ["TÔLES GALVANISÉES"]),
    ("043", "MAROC RESINE", "Travaux de résine", ["RÉSINE"]),
    ("044", "LOCA BATI", "Travaux projetés", ["PROJECTION ET ENDUITS"]),
    ("045", "ATIFI", "Travaux projetés", ["PROJECTION ET ENDUITS"]),
    ("046", "YOUKA", "Travaux d'espaces verts", ["ESPACES VERTS"]),
    ("047", "AFRIQUIA", "Carburant", ["CARBURANT"]),
    ("048", "10 RAJEB", "Menuiserie bois", ["MENUISERIE BOIS"]),
    ("049", "DAHBI LEVAGE", "Location de nacelle", ["LOCATION DE NACELLES", "LOCATION D'ENGINS"]),
    ("050", "CCMM", "Fourniture de garde-corps", ["GARDE-CORPS", "MÉTALLERIE"]),
    ("051", "LEG", "Laboratoire", ["LABORATOIRE"]),
    ("052", "IDUTRANS", "Transport", ["TRANSPORT"]),
    ("053", "KASKETE", "Pose de carrelage", ["CARRELAGE"]),
    ("054", "BEGGAR", "Menuiserie métallique", ["MENUISERIE MÉTALLIQUE", "MÉTALLERIE"]),
    ("055", "BASCALS", "Skydome", ["SKYDOME"]),
    ("056", "COPREF", "Agrégats et ciment", ["AGRÉGATS", "CIMENT"]),
    ("057", "FOGEBAT", "Fourniture de plomberie PVC", ["PLOMBERIE PVC"]),
    ("058", "COGEPRA", "Fourniture de pompes", ["POMPES"]),
    ("059", "KHOUCHAR", "Portes automatiques, coulissantes et sectionnelles", ["PORTES AUTOMATIQUES ET SECTIONNELLES"]),
    ("060", "SOREX", "Fournitures de magasin", ["FOURNITURES DE MAGASIN"]),
    ("061", "BE2S", "Fourniture de pavés et bordures", ["PAVÉS ET BORDURES"]),
    ("062", "EVOLUTRL", "CFA — courant faible", ["CFA — COURANT FAIBLE"]),
    ("063", "FREEZELEC", "CFO — courant fort", ["CFO — COURANT FORT"]),
    ("064", "VERCOS", "Habillage", ["HABILLAGE"]),
    ("065", "SEPARATOR", "Menuiserie aluminium", ["MENUISERIE ALUMINIUM"]),
    ("066", "kamal", "Pose de carrelage", ["CARRELAGE"]),
    ("067", "el hossine", "Citerne d'eau", ["CITERNE D'EAU"]),
    ("068", "UNITON BUILDING", "Pose de carrelage", ["CARRELAGE"])
]

def execute():
    print("=== EXECUTING TG2D PAPERLESS-NGX CONFIGURATION ===")
    
    # 1. Phase 4: Create Activity Tags
    print("\n[Phase 4] Creating Activity Tags...")
    tag_map = {}
    tags_created = 0
    tags_reused = 0
    for name in ACTIVITY_TAGS:
        tag, created = Tag.objects.get_or_create(
            name=name,
            defaults={"matching_algorithm": 1, "match": "", "is_insensitive": True}
        )
        tag_map[name] = tag
        if created:
            tags_created += 1
        else:
            tags_reused += 1
    print(f"-> Tags processed: {len(tag_map)} (Created: {tags_created}, Reused: {tags_reused})")

    # 2. Phase 5: Create Document Types
    print("\n[Phase 5] Creating Document Types...")
    doc_type_map = {}
    dt_created = 0
    dt_reused = 0
    for dt_name, match_str in DOCUMENT_TYPES:
        dt, created = DocumentType.objects.get_or_create(
            name=dt_name,
            defaults={"matching_algorithm": 1 if match_str else 0, "match": match_str, "is_insensitive": True}
        )
        doc_type_map[dt_name] = dt
        if created:
            dt_created += 1
        else:
            dt_reused += 1
    print(f"-> Document Types processed: {len(doc_type_map)} (Created: {dt_created}, Reused: {dt_reused})")

    # 3. Phase 3: Create Suppliers / Correspondents
    print("\n[Phase 3] Creating Correspondents...")
    supplier_data = {}
    for sid, name, act, tags in SUPPLIER_ROWS:
        if name not in supplier_data:
            supplier_data[name] = {
                "ids": [sid],
                "activities": [act],
                "tags": set(tags)
            }
        else:
            supplier_data[name]["ids"].append(sid)
            supplier_data[name]["activities"].append(act)
            supplier_data[name]["tags"].update(tags)

    corr_map = {}
    corr_created = 0
    corr_reused = 0
    for name, data in supplier_data.items():
        corr, created = Correspondent.objects.get_or_create(
            name=name,
            defaults={"matching_algorithm": 1, "match": name, "is_insensitive": True}
        )
        corr_map[name] = corr
        if created:
            corr_created += 1
        else:
            corr_reused += 1
    print(f"-> Correspondents processed: {len(corr_map)} (Created: {corr_created}, Reused: {corr_reused})")

    # 4. Phase 7: Activity Classification Workflows
    # Group correspondents by Activity Tag so each activity has a single clean workflow
    print("\n[Phase 7] Configuring Automated Classification Workflows...")
    activity_to_corrs = {}
    for name, data in supplier_data.items():
        corr = corr_map[name]
        for t_name in data["tags"]:
            if t_name not in activity_to_corrs:
                activity_to_corrs[t_name] = []
            activity_to_corrs[t_name].append(corr)

    wf_created = 0
    wf_reused = 0
    for t_name, corrs in activity_to_corrs.items():
        if t_name not in tag_map:
            continue
        tag_obj = tag_map[t_name]
        wf_name = f"Activité: {t_name}"
        
        wf, created = Workflow.objects.get_or_create(
            name=wf_name,
            defaults={"order": 20, "enabled": True}
        )
        if created:
            wf_created += 1
            # Trigger when document is added with any of these correspondents
            trigger = WorkflowTrigger.objects.create(
                type=2, # Document Added
                matching_algorithm=0
            )
            trigger.filter_has_any_correspondents.set(corrs)
            wf.triggers.add(trigger)
            
            # Action: assign activity tag
            action = WorkflowAction.objects.create(
                type=1, # Assignment
                order=1
            )
            action.assign_tags.add(tag_obj)
            wf.actions.add(action)
        else:
            wf_reused += 1

    print(f"-> Activity Workflows: {len(activity_to_corrs)} (Created: {wf_created}, Reused: {wf_reused})")

    # 5. Document Type Classification Workflows
    dt_wf_created = 0
    dt_wf_reused = 0
    for dt_name, match_str in DOCUMENT_TYPES:
        if not match_str:
            continue
        dt_obj = doc_type_map[dt_name]
        wf_name = f"Classification: {dt_name}"
        wf, created = Workflow.objects.get_or_create(
            name=wf_name,
            defaults={"order": 10, "enabled": True}
        )
        if created:
            dt_wf_created += 1
            trigger = WorkflowTrigger.objects.create(
                type=2, # Document Added
                match=match_str,
                matching_algorithm=1, # Any word
                is_insensitive=True
            )
            wf.triggers.add(trigger)
            action = WorkflowAction.objects.create(
                type=1,
                order=1,
                assign_document_type=dt_obj
            )
            wf.actions.add(action)
        else:
            dt_wf_reused += 1

    print(f"-> Document Type Workflows: Created: {dt_wf_created}, Reused: {dt_wf_reused}")

    print("\n=== IMPLEMENTATION VERIFICATION ===")
    print(f"Total Correspondents in DB: {Correspondent.objects.count()}")
    print(f"Total Tags in DB: {Tag.objects.count()}")
    print(f"Total Document Types in DB: {DocumentType.objects.count()}")
    print(f"Total Workflows in DB: {Workflow.objects.count()}")
    
    return {
        "tags_count": Tag.objects.count(),
        "doctypes_count": DocumentType.objects.count(),
        "correspondents_count": Correspondent.objects.count(),
        "workflows_count": Workflow.objects.count()
    }

execute()
