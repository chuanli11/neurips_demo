mkdir -p $INPUT_DIR &&
mkdir -p $PRED_DIR &&
mkdir -p $MODEL_DIR &&
mkdir -p $CLASS_DATA_DIR &&
cp "${STORAGE_DIR}/${DREAMBOOTH_CODE_DIR}/helper.py" "${STORAGE_DIR}/person/${RUN_ID}" &&
cp "${STORAGE_DIR}/${DREAMBOOTH_CODE_DIR}/test.ipynb" "${STORAGE_DIR}/person/${RUN_ID}/test_${RUN_ID}.ipynb" &&
sed -i "s/chuanli/${RUN_ID}/g" "${STORAGE_DIR}/person/${RUN_ID}/test_${RUN_ID}.ipynb"