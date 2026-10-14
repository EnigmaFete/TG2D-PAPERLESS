import sys
from documents.models import Correspondent, SavedView, SavedViewFilterRule, UiSettings
from django.contrib.auth.models import User

def setup_company_views():
    corrs = list(Correspondent.objects.all().order_by('name'))
    print(f"Setting up views for {len(corrs)} suppliers...")
    
    view_ids = []
    created_count = 0
    reused_count = 0
    
    for corr in corrs:
        view, created = SavedView.objects.get_or_create(
            name=corr.name,
            defaults={
                'owner': None,
                'sort_field': 'created',
                'sort_reverse': True,
                'page_size': 25,
                'display_mode': 'table'
            }
        )
        if created:
            created_count += 1
        else:
            reused_count += 1
            
        SavedViewFilterRule.objects.get_or_create(
            saved_view=view,
            rule_type=3, # Correspondent is
            value=str(corr.id)
        )
        view_ids.append(view.id)
        
    print(f"SavedViews: {created_count} created, {reused_count} reused (Total: {len(view_ids)})")
    
    # Configure UiSettings for all users so all views show on Dashboard and in Sidebar
    for user in User.objects.all():
        ui, _ = UiSettings.objects.get_or_create(
            user=user,
            defaults={'settings': {}}
        )
        settings = dict(ui.settings) if isinstance(ui.settings, dict) else {}
        sv_settings = dict(settings.get('saved_views', {})) if isinstance(settings.get('saved_views'), dict) else {}
        
        # Merge view_ids into dashboard and sidebar visible lists
        cur_dash = sv_settings.get('dashboard_views_visible_ids', [])
        cur_dash_order = sv_settings.get('dashboard_views_sort_order', [])
        cur_side = sv_settings.get('sidebar_views_visible_ids', [])
        
        # Set all views visible in alphabetical order
        sv_settings['dashboard_views_visible_ids'] = list(dict.fromkeys(view_ids + [i for i in cur_dash if i not in view_ids]))
        sv_settings['dashboard_views_sort_order'] = list(dict.fromkeys(view_ids + [i for i in cur_dash_order if i not in view_ids]))
        sv_settings['sidebar_views_visible_ids'] = list(dict.fromkeys(view_ids + [i for i in cur_side if i not in view_ids]))
        
        settings['saved_views'] = sv_settings
        ui.settings = settings
        ui.save()
        print(f"Updated UiSettings for user: {user.username}")
        
    print("All company views successfully configured!")

if __name__ == "__main__":
    setup_company_views()
