# ---------- 1. Build-Stage ----------
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --user -r requirements.txt

# ---------- 2. Runtime-Stage ----------
FROM python:3.11-slim
WORKDIR /app
ENV PYTHONPATH=/app

# ---- NEU: installierte Pakete rüberkopieren ----
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
# -----------------------------------------------

# ---------- Projektdateien ----------
# Bartek-Workflow
COPY Bartek/output /app/Bartek/output
COPY Bartek/input  /app/Bartek/input
# Arno-Workflow
COPY Arno/output   /app/Arno/output
COPY Arno/input    /app/Arno/input

# --------- Default Entry Point -------
ENTRYPOINT ["python", "Bartek/output/run_calc.py"]
    