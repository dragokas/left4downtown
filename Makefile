# (C)2004-2008 SourceMod Development Team
# Makefile written by David "BAILOPAN" Anderson

SMSDK = ../sourcemod
MMSOURCE17 = ../mmsource-1.10
HL2SDK_ORIG = ../hl2sdk
HL2SDK_OB = ../hl2sdk-ob
HL2SDK_OB_VALVE = ../hl2sdk-ob-valve
HL2SDK_L4D = ../hl2sdk-l4d
HL2SDK_L4D2 = ../hl2sdk-l4d2
SRCDS_BASE = ../hl2sdk-l4d

#####################################
### EDIT BELOW FOR OTHER PROJECTS ###
#####################################

PROJECT = left4downtown

#Uncomment for Metamod: Source enabled extension
USEMETA = true

OBJECTS = sdk/smsdk_ext.cpp extension.cpp natives.cpp vglobals.cpp util.cpp asm/asm.c \
			detours/detour.cpp detours/recalculate_versus_score.cpp detours/spawn_tank.cpp detours/spawn_witch.cpp detours/clear_team_scores.cpp \
			detours/set_campaign_scores.cpp detours/first_survivor_left_safe_area.cpp detours/mob_rush_start.cpp detours/try_offering_tank_bot.cpp \
			detours/select_weighted_sequence.cpp detours/send_in_rescue_vehicle.cpp detours/shoved_by_survivor.cpp detours/terror_weapon_hit.cpp \
			codepatch/patchmanager.cpp

##############################################
### CONFIGURE ANY OTHER FLAGS/OPTIONS HERE ###
##############################################

C_OPT_FLAGS = -DNDEBUG -O3 -funroll-loops -pipe -fno-strict-aliasing
C_DEBUG_FLAGS = -D_DEBUG -DDEBUG -g -ggdb3
C_GCC4_FLAGS = -fvisibility=hidden
CPP_GCC4_FLAGS = -fvisibility-inlines-hidden
CPP = gcc

override ENGSET = false
ifeq "$(BUILD)" "slots"
        CFLAGS += -DUSE_PLAYERSLOTS_PATCHES=1
        OBJECTS += player_slots.cpp detours/server_player_counts.cpp
        override ENGSET = true
endif
ifeq "$(BUILD)" "noslots"
        override ENGSET = true
endif

HL2SDK = $(HL2SDK_L4D)
HL2PUB = $(HL2SDK)/public
HL2LIB = $(HL2SDK)/lib/linux
CFLAGS += -DSOURCE_ENGINE=8
METAMOD = $(MMSOURCE17)/core
INCLUDE += -I$(HL2SDK)/public/game/server -I$(HL2SDK)/common -I$(HL2SDK)/game/shared
SRCDS = $(SRCDS_BASE)/lib/linux
GAMEFIX = 2.l4d

LINK_HL2 = $(HL2LIB)/tier1_i486.a $(HL2LIB)/mathlib_i486.a libvstdlib.so libtier0.so
LINK += $(LINK_HL2)

INCLUDE += -I. -I.. -Isdk -I$(HL2PUB) -I$(HL2PUB)/engine -I$(HL2PUB)/mathlib -I$(HL2PUB)/tier0 \
        -I$(HL2PUB)/tier1 -I$(METAMOD) -I$(METAMOD)/sourcehook -I$(SMSDK)/public -I$(SMSDK)/public/extensions \
        -I$(SMSDK)/sourcepawn -I$(SMSDK)/sourcepawn/include -I$(SMSDK)/public/amtl -I$(SMSDK)/public/amtl/amtl
CFLAGS += -DSE_EPISODEONE=1 -DSE_DARKMESSIAH=2 -DSE_ORANGEBOX=3 -DSE_BLOODYGOODTIME=4 -DSE_EYE=5 \
	-DSE_CSS=6 -DSE_ORANGEBOXVALVE=7 -DSE_LEFT4DEAD=8 -DSE_LEFT4DEAD2=9 -DSE_ALIENSWARM=10
	-DSE_PORTAL2=11 -DSE_CSGO=12

LINK += -m32 -ldl -lm

CFLAGS += -D_LINUX -Dstricmp=strcasecmp -D_stricmp=strcasecmp -D_strnicmp=strncasecmp -Dstrnicmp=strncasecmp \
        -D_snprintf=snprintf -D_vsnprintf=vsnprintf -D_alloca=alloca -Dstrcmpi=strcasecmp -Wall -Werror -Wno-switch \
        -Wno-unused -mfpmath=sse -msse -DSOURCEMOD_BUILD -DHAVE_STDINT_H -m32
CPPFLAGS += -Wno-non-virtual-dtor -fno-exceptions -fno-rtti -fno-threadsafe-statics -std=c++11

################################################
### DO NOT EDIT BELOW HERE FOR MOST PROJECTS ###
################################################

ifeq "$(DEBUG)" "true"
	BIN_DIR = Debug
	CFLAGS += $(C_DEBUG_FLAGS)
else
	BIN_DIR = Release
	CFLAGS += $(C_OPT_FLAGS)
endif

ifeq "$(USEMETA)" "true"
    ifeq "$(BUILD)" "slots"
		BIN_DIR := $(BIN_DIR).PlayerSlots
    endif
    ifeq "$(BUILD)" "noslots"
		BIN_DIR := $(BIN_DIR).NoPlayerSlots
    endif
endif

OS := $(shell uname -s)
ifeq "$(OS)" "Darwin"
	LINK += -dynamiclib
	BINARY = $(PROJECT).ext.$(GAMEFIX).dylib
else
	LINK += -static-libgcc -shared
	BINARY = $(PROJECT).ext.$(GAMEFIX).so
endif

GCC_VERSION := $(shell $(CPP) -dumpversion >&1 | cut -b1)
ifeq "$(GCC_VERSION)" "4"
	CFLAGS += $(C_GCC4_FLAGS)
	CPPFLAGS += $(CPP_GCC4_FLAGS)
endif

OBJ_LINUX := $(OBJECTS:%.cpp=$(BIN_DIR)/%.o)

$(BIN_DIR)/%.o: %.cpp
	$(CPP) $(INCLUDE) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

all: check
	mkdir -p $(BIN_DIR)/sdk
	mkdir -p $(BIN_DIR)/detours
	mkdir -p $(BIN_DIR)/codepatch
	cp $(SRCDS)/libvstdlib.so libvstdlib.so;
	cp $(SRCDS)/libtier0.so libtier0.so;
	$(MAKE) -f Makefile extension

check:
	if [ "$(USEMETA)" = "true" ] && [ "$(ENGSET)" = "false" ]; then \
		echo "You must supply BUILD=slots or BUILD=noslots"; \
		exit 1; \
    fi

extension: check $(OBJ_LINUX)
	$(CPP) $(INCLUDE) $(OBJ_LINUX) $(LINK) -o $(BIN_DIR)/$(BINARY) -Wno-implicit-function-declaration

debug:
	$(MAKE) -f Makefile all DEBUG=true

default: all

clean: check
	find $(BIN_DIR) -iname *.o | xargs rm -f
	rm -rf $(BIN_DIR)/$(BINARY)
	rm ./*.so
