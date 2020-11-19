/**
 * vim: set ts=4 :
 * =============================================================================
 * Left 4 Downtown SourceMod Extension
 * Copyright (C) 2009 Igor "Downtown1" Smirnov.
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 *
 * Version: $Id$
 */

#include "terror_weapon_hit.h"
#include "extension.h"

namespace Detours
{
    void *TerrorWeaponHit::OnTerrorWeaponHit(CGameTrace *trace/* a1 */, void *vector/* a2 */, bool userCall/* a3 */)
    {
        L4D_DEBUG_LOG("CTerrorWeapon::OnHit() has been called");
        cell_t result = Pl_Continue;

		static int offsetWeaponOwner = -1;

		if (offsetWeaponOwner == -1 && !g_pGameConf->GetOffset("OnTerrorWeaponHit::weaponOwner", &offsetWeaponOwner))
		{
			g_pSM->LogError(myself, "Could not find 'OnTerrorWeaponHit::weaponOwner' offset");
		}

        int hEntity = *(int *)((unsigned char*)trace + 76);    // did the m2 trace hit anyone(i.e. an entity)
        int weapon = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity *>(this)));
        int entity = IndexOfEdict(gameents->BaseEntityToEdict(reinterpret_cast<CBaseEntity *>(hEntity)));
		CBaseHandle &weaponOwner = *(CBaseHandle *)((unsigned char *)this + offsetWeaponOwner);  // get the weapon's owner and thus check its validity(shoves are a secondary attack of anything you're able to hold, even pills and cola)
		int client = !weaponOwner.IsValid() ? -1 : weaponOwner.GetEntryIndex();   // very simplistic and unreliable check, but meh

		L4D_DEBUG_LOG("CTerrorWeapon::OnHit() hEntity=%d, client=%d, weapon=%d, target=%d", hEntity, client, weapon, entity);

        /* there's another check being performed here to see if the current gamemode allows bashing... we don't need it */
        if (g_pFwdOnTerrorWeaponHit && client && entity)
        {
            g_pFwdOnTerrorWeaponHit->PushCell(client); // who shoved
            g_pFwdOnTerrorWeaponHit->PushCell(entity); // who got shoved
            g_pFwdOnTerrorWeaponHit->PushCell(weapon); // weapon that's been held while shoving
            g_pFwdOnTerrorWeaponHit->PushArray(reinterpret_cast<cell_t *>(vector), 3); // shove angles
            g_pFwdOnTerrorWeaponHit->Execute(&result);
        }

        if(result == Pl_Handled)
        {
            L4D_DEBUG_LOG("CTerrorWeapon::OnHit() will be skipped");
            return NULL;
        }
        else
        {
            return (this->*(GetTrampoline()))(trace, vector, userCall);
        }
    }
};
