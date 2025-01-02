#!/usr/bin/env bats

setup() {
    tmpdir=/tmp/espnet2-test-evaluate-f0-${RANDOM}
    # Create dummy data
    mkdir -p ${tmpdir}/data
    python << EOF
import numpy as np
import soundfile as sf
sf.write("${tmpdir}/data/dummy.wav", np.random.randn(3000), 16000)
EOF
}

teardown() {
    # Clean up temporary files
    rm -rf "${tmpdir}"
}

@test "evaluate_ASR_WER" {
    python3 -c "import versa" >/dev/null 2>&1 || skip "VERSA is not installed"
    # Navigate to the required directory
    cd egs2/spoken_chatbot_arena/sds1

    # Run the test logic
    python3 << EOF
import soundfile as sf
from pyscripts.utils.dialog_eval.ASR_WER import handle_espnet_ASR_WER

# Read dummy audio
audio_output, rate = sf.read("${tmpdir}/data/dummy.wav")

handle_espnet_ASR_WER((rate, audio_output), "This is dummy text")
EOF
}

@test "evaluate_LLM_Metrics_perplexity" {
    python3 -c "import evaluate" >/dev/null 2>&1 || skip "evaluate is not installed"
    python3 -c "import transformers" >/dev/null 2>&1 || skip "transformers is not installed"
    # Navigate to the required directory
    cd egs2/spoken_chatbot_arena/sds1

    # Run the test logic
    python3 << EOF
from pyscripts.utils.dialog_eval.LLM_Metrics import (
    DialoGPT_perplexity,
    bert_score,
    perplexity,
    vert,
)

perplexity("This is dummy text")
vert(["This is dummy text"+str(i) for i in range(10)])
bert_score(["This is dummy text"+str(i) for i in range(10)])
DialoGPT_perplexity("This is dummy text1", "This is dummy text2")
EOF
}

@test "evaluate_TTS_intelligibility" {
    python3 -c "import versa" >/dev/null 2>&1 || skip "VERSA is not installed"
    # Navigate to the required directory
    cd egs2/spoken_chatbot_arena/sds1

    # Run the test logic
    python3 << EOF
import soundfile as sf
from pyscripts.utils.dialog_eval.TTS_intelligibility import handle_espnet_TTS_intelligibility

# Read dummy audio
audio_output, rate = sf.read("${tmpdir}/data/dummy.wav")

handle_espnet_TTS_intelligibility((rate, audio_output), "This is dummy text")
EOF
}

@test "evaluate_TTS_quality" {
    python3 -c "import versa" >/dev/null 2>&1 || skip "VERSA is not installed"
    # Navigate to the required directory
    cd egs2/spoken_chatbot_arena/sds1

    # Run the test logic
    python3 << EOF
import soundfile as sf
from pyscripts.utils.dialog_eval.TTS_speech_quality import TTS_psuedomos

# Read dummy audio
audio_output, rate = sf.read("${tmpdir}/data/dummy.wav")

TTS_psuedomos((rate, audio_output))
EOF
}
