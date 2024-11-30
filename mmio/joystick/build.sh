#!/bin/bash

OUTPUT_NAME=joystick
LINK_SCRIPT=STM32C011F6.ld
LIBRARY_PATH=.build/checkouts/swift-stm32c011
TARGETS="build link map lst size bin"

if [ ! -d $LIBRARY_PATH ]; then
    echo "$LIBRARY_PATH is not checked out, resolving packages..."
    swift package resolve
fi

make -f $LIBRARY_PATH/build.mk \
    OUTPUT_NAME=$OUTPUT_NAME \
    LINK_SCRIPT=$LINK_SCRIPT \
    $TARGETS
