#!/bin/bash

function load_env_variables {
    if [ -f .env ]; then
        set -a
        source .env
        set +a
    else
        echo ".env file not found" >&2
        exit 1
    fi
}

function check_region_url_env_variable_exists {
    if [ -z "$REGION_URL" ]; then
        echo "REGION_URL enviroment variable is not set or empty"
        exit 1
    fi
}

function check_lua_script_env_variable_exists {
    if [ -z "$LUA_SCRIPT" ]; then
        echo "LUA_SCRIPT enviroment variable is not set or empty"
        exit 1
    fi
}

function check_restriction_env_variable_exists {
    if [ -z "$RESTRICTION" ]; then
        echo "RESTRICTION enviroment variable is not set or empty"
        exit 1
    fi
}

function check_db_variables_exist {
    if [ -z "$PG_HOST" ]; then
        echo "PG_HOST enviroment variable is not set or empty"
        exit 1
    fi

    if [ -z "$PG_PORT" ]; then
        echo "PG_PORT enviroment variable is not set or empty"
        exit 1
    fi

    if [ -z "$PG_USER" ]; then
        echo "PG_USER enviroment variable is not set or empty"
        exit 1
    fi

    if [ -z "$PG_DB" ]; then
        echo "PG_DB enviroment variable is not set or empty"
        exit 1
    fi

    if [ -z "$PGPASSWORD" ]; then
        echo "PGPASSWORD enviroment variable is not set or empty"
        exit 1
    fi
}

function check_maintenance_db_env_variable_exist {
    if [ -z "$PG_MAINTENANCE_DB" ]; then
        echo "PG_MAINTENANCE_DB enviroment variable is not set or empty"
        exit 1
    fi
}
