# Variables to override:
#
# MIX_COMPILE_PATH path to the build's ebin directory
#
# CC            C compiler
# CROSSCOMPILE	crosscompiler prefix, if any
# CFLAGS	compiler flags for compiling all C files
# ERL_CFLAGS	additional compiler flags for files using Erlang header files
# ERL_EI_INCLUDE_DIR include path to ei.h (Required for crosscompile)
# LDFLAGS	linker flags for linking all binaries

ifeq ($(MIX_COMPILE_PATH),)
	$(error MIX_COMPILE_PATH should be set by elixir_make!)
endif

MIX := mix
CC ?= $(CROSSCOMPILE)-gcc

PREFIX = $(MIX_COMPILE_PATH)/../priv
BUILD  = $(MIX_COMPILE_PATH)/../obj

CFLAGS := -Ofast -g -ansi -pedantic

# The paths to the EI library and header files are either passed in when
# compiled by Nerves (crosscompiled builds) or determined by mix.exs for
# host builds.
ifeq ($(ERL_EI_INCLUDE_DIR),)
$(error ERL_EI_INCLUDE_DIR not set. Invoke via mix)
endif

# Set Erlang-specific compile and linker flags
ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)

CFLAGS += -I/usr/local/include -I/usr/include -L/usr/local/lib -L/usr/lib
CFLAGS += -std=c11 -Wno-unused-function
ifeq ($(origin CROSSCOMPILE), undefined)
	CFLAGS += -femit-all-decls
	ifeq ($(shell uname),Darwin)
			LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
else
	ifneq ($(OS),Windows_NT)
		CFLAGS += -fPIC
	endif
endif



calling_from_make:
	mix compile

.PHONY: all libnifvec clean

all: $(BUILD) $(PREFIX) $(PREFIX)/libnif.so

# native/lib.s: native/lib.c
# 		$(CC) $(CFLAGS) -c -S -o $@ $^

$(PREFIX)/libnif.so: native/lib.c
		$(CC) $(ERL_CFLAGS) $(CFLAGS) -shared $(LDFLAGS) -o $@ $^

$(PREFIX):
	mkdir -p $@

$(BUILD):
	mkdir -p $@

clean:
		$(RM) -rf $(PREFIX)/*
