#!/bin/bash

TEST_DATETIME=$(python ./utils/getdate.py)
robot -d ./logs/$TEST_DATETIME --variable RESOURCE_DIR:$(pwd)/resources ./tests/*
#robot -d test-logs/ test-suites/