FROM python:3.10-slim AS builder
WORKDIR /app

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.10-slim
WORKDIR /app

RUN useradd -r -M -s /bin/false flaskuser

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY . .

RUN chown -R flaskuser:flaskuser /app

USER flaskuser

EXPOSE 5000

ENV PORT=5000
ENV BACKEND_URL="http://localhost:3000"

CMD ["python", "app.py"]