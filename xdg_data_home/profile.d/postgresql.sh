if hash psql 2>/dev/null; then
  export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
  export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
  export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"
  mkdir -p "$XDG_CONFIG_HOME/pg"
  export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
fi
