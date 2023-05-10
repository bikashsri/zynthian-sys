#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Run Update Recipes
# 
# Run the scripts contained in recipes.update directory
# 
# Copyright (C) 2015-2017 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
# ****************************************************************************

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"
source "$ZYNTHIAN_SYS_DIR/scripts/delayed_action_flags.sh"

#------------------------------------------------------------------------------
# Run update recipes ...
#------------------------------------------------------------------------------

RECIPES_UPDATE_DIR="$ZYNTHIAN_SYS_DIR/scripts/recipes.update"

#Custom update recipes, depending on the codebase version
echo "Executing custom update recipes..."
for r in $RECIPES_UPDATE_DIR.${LINUX_OS_VERSION}/*.sh; do
	echo "Executing $r ..."
	bash $r
done

#Generic update recipes
if [[ ! "$ZYNTHIAN_SYS_BRANCH" =~ ^stable.* ]] || [[ "$ZYNTHIAN_FORCE_UPGRADE" == "yes" ]]; then
	echo "Executing update recipes ..."
	for r in $RECIPES_UPDATE_DIR/*.sh; do
		echo "Executing $r ..."
		bash $r
	done
fi
	
run_flag_actions

#------------------------------------------------------------------------------
