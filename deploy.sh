#!/bin/bash
# Deploy to CSE servers.
# IMPORTANT: Change tmp to your game name before using.
rsync -r export/html5/bin/ attu.cs.washington.edu:/projects/instr/cse481d/18sp/games/costume
