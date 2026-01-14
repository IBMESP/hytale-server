# Hytale Docker Server

A Docker-based Hytale server deployment for easy setup and management.

## How to use

### 1. Start the Server

Launch the server in detached mode:

```bash
docker compose up -d
```

### 2. Monitor Logs

Watch the server logs to find the authentication verification link:

```bash
docker-compose logs -f
```

Copy the verification link that appears in the logs for authentication.

### 3. Server Authentication

Once the server has downloaded and started, attach to the container:

```bash
docker attach hytale
```

Then authenticate the server:

```bash
/auth login device
```

### 4. (Optional) Enable Persistent Authentication

To avoid having to log in every time the server restarts, enable encrypted persistence:

```bash
/auth persistence Encrypted
```

This step is optional but recommended for convenience.

## Notes

- The authentication link will appear in the logs during the first startup
- Encrypted persistence stores your authentication credentials securely
- Use `Ctrl+P` followed by `Ctrl+Q` to detach from the container without stopping it

## Troubleshooting

If you need to restart the server:

```bash
docker compose down
docker compose up -d
```

To stop the server completely:

```bash
docker compose down
```

## Support

[Hytale Server Manual](https://support.hytale.com/hc/en-us/articles/45326769420827-Hytale-Server-Manual)
[Issues](https://github.com/IBMESP/hytale-server/issues)
