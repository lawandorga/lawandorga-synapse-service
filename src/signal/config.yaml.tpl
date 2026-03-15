# Network-specific config options
network:
    displayname_template: '{{or .ProfileName .PhoneNumber "Unknown user"}}'
    device_name: mautrix-signal

# Config options that affect the central bridge module.
bridge:
    command_prefix: '!signal'
    personal_filtering_spaces: true
    permissions:
        "*": relay
        "law-orga.de": user

# Encryption config.
encryption:
    allow: true
    default: true
    require: false
    appservice: true
    self_sign: true
    pickle_key: ${signal_pickle_key}

# Config for the bridge's database.
database:
    type: postgres
    uri: postgres://synapse:${signal_db_password}@195.154.71.232:30659/lawandorga-mautrix-signal
    max_open_conns: 5
    max_idle_conns: 1

# Homeserver details.
homeserver:
    address: http://lawandorga-synapse-service
    domain: law-orga.de
    software: standard

# Application service host/registration related details.
appservice:
    address: http://mautrix-signal:29328
    hostname: 0.0.0.0
    port: 29328
    id: signal
    bot:
        username: signalbot
        displayname: Signal bridge bot
        avatar: mxc://maunium.net/wPJgTQbZOtpBFmDNkiNEMDUp
    ephemeral_events: true
    as_token: "${signal_as_token}"
    hs_token: "${signal_hs_token}"
    username_template: signal_{{.}}

# Logging config.
logging:
    min_level: debug
    writers:
        - type: stdout
          format: pretty-colored
