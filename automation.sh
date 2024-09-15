#!/bin/bash
# Automation script that runs after a stream goes offline

if [[ -z "$BILIBILI_DIR" ]]; then
    echo "BILIBILI_DIR not set"
    exit 1
fi

if [[ -z "$NEURO_CHAT_DIR" ]]; then
    echo "NEURO_CHAT_DIR not set"
    exit 1
fi

if [[ -z "$NEURO_CHAT_PUBLISH_DIR" ]]; then
    echo "NEURO_CHAT_PUBLISH_DIR not set"
    exit 1
fi

if [[ -z "$CASUAL_PXLS_DIR" ]]; then
    echo "CASUAL_PXLS_DIR not set"
    exit 1
fi

if [[ -z "$IRONMOUSE_PXLS_DIR" ]]; then
    echo "IRONMOUSE_PXLS_DIR not set"
    exit 1
fi

# moves processes bilibili
cp "$BILIBILI_DIR/output.txt" output.txt
python3 convert_bili_json.py
cp output_fixed_fixed.json "$NEURO_CHAT_DIR/rust"

# copy casual local.db and process them
cp "$CASUAL_PXLS_DIR/local.db" input.db
python3 sqlite_to_json.py
cp output.json $NEURO_CHAT_DIR/rust/pxls.json

# copy ironmouse local.db and process them
cp "$IRONMOUSE_PXLS_DIR/local.db" input.db
python3 sqlite_to_json.py
cp output.json $NEURO_CHAT_DIR/rust/pxls_ironmouse.json

# run neuro chat elo
pushd $NEURO_CHAT_DIR/rust
# cargo run -r
cp *.bin $NEURO_CHAT_PUBLISH_DIR/
popd

# publish changes
pushd $NEURO_CHAT_PUBLISH_DIR
git add .
git commit -m "partial automation"
git push
popd
