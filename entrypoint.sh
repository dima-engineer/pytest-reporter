#!/bin/bash -x

VARIABLE="abc"

echo "$VARIABLE"

ls
ls /

if [ -d /code ]
then
  ls /code
fi
