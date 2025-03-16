# Usa Python 3.12 como imagen base
FROM python:3.12

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Instala Poetry
ENV POETRY_VERSION=1.8.5
ENV POETRY_HOME=/opt/poetry
ENV PATH="${POETRY_HOME}/bin:${PATH}"
RUN curl -sSL https://install.python-poetry.org | python3 - --version ${POETRY_VERSION}

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de dependencias y los instala
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --no-dev  # No instala dependencias de desarrollo para reducir tamaño

# Copia el resto del código fuente al contenedor
COPY . .

# Expone el puerto 80 para que Azure pueda acceder a la aplicación
EXPOSE 80

# Ejecuta la aplicación con Uvicorn
CMD ["poetry", "run", "uvicorn", "dtw_lab.lab2:app", "--host", "0.0.0.0", "--port", "80"]
