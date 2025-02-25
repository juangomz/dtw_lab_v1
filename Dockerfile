
# Usa Python 3.12 como imagen base
FROM python:3.12

# Install system dependencies, including Git and gnupg
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
ENV POETRY_VERSION=1.8.5
ENV POETRY_HOME=/opt/poetry
ENV PATH="${POETRY_HOME}/bin:${PATH}"
RUN curl -sSL https://install.python-poetry.org | python3 - --version ${POETRY_VERSION}


# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia solo los archivos de dependencias primero (para aprovechar la caché de Docker)
COPY pyproject.toml poetry.lock ./

# Instala Poetry en el contenedor
# RUN pip install poetry

# Instala las dependencias del proyecto usando Poetry
RUN poetry install --no-root

# Copia el resto del código fuente al contenedor
COPY . .

RUN poetry install

# Expone el puerto 80 en el contenedor
EXPOSE 80

# Usa Poetry para ejecutar la aplicación
CMD ["poetry", "run", "start-server"]
