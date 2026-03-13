#!/bin/bash
set -e

DATA_DIR=/var/lib/mysql
SOCKET_DIR=/run/mysqld

# Créer le dossier de socket si inexistant
mkdir -p $SOCKET_DIR
chown -R mysql:mysql $SOCKET_DIR

# Initialisation si la DB n'existe pas
if [ ! -d "$DATA_DIR/mysql" ]; then
    echo "[MariaDB] Initialisation de la base de données..."

    mariadb-install-db --user=mysql --datadir="$DATA_DIR"

    # Lancer temporairement mysqld pour exécuter le script SQL
    mysqld --datadir="$DATA_DIR" --socket="$SOCKET_DIR/mysqld.sock" --skip-networking &
    pid=$!

    until mysqladmin ping --silent; do
        echo "[MariaDB] Pas encore prêt, attente 5s..."
        sleep 5
    done

    echo "[MariaDB] Exécution du script SQL..."
    mysql -u root < /init.sql

    # Arrêter le serveur temporaire
    mysqladmin -u root shutdown
    wait $pid
fi

# Assurer les permissions
chown -R mysql:mysql "$DATA_DIR"

echo "[MariaDB] Démarrage en premier plan..."
exec mysqld --user=mysql --datadir="$DATA_DIR" --socket="$SOCKET_DIR/mysqld.sock" --bind-address=0.0.0.0