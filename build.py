import subprocess
import os

# Caminho para o seu projeto dbt
dbt_dir = "dbt_project"

# Lista de comandos a serem executados
commands = [
    ["dbt", "build"],
    ["dbt", "docs", "generate"],
    ["dbt", "docs", "serve", "--port", "8081"]
]

# Salva o diretório atual
original_dir = os.getcwd()

try:
    # Muda para o diretório do projeto dbt
    os.chdir(dbt_dir)

    # Executa cada comando
    for cmd in commands:
        print(f"Executando: {' '.join(cmd)}")
        subprocess.run(cmd, check=True)
finally:
    # Volta para o diretório original
    os.chdir(original_dir)