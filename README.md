# Cozycraft Terraform
## What is Cozycraft?
Cozycraft is a community ran Minecraft survival multiplayer server. This architecture allows for ease-of-cost, ease-of-scale, and ease-of-maintainability. Standing on the shoulders of giants.

## Usage
1. Create an account on [fly.io](https://fly.io)
2. Install flyctl

### Unix
3. In one terminal run this: `flyctl machine api-proxy`
4. In another terminal run this: `export FLY_API_TOKEN=$(flyctl auth token)`


## Environment Variables
In an new file, named whatever you'd like `.tfvars` (e.g. `dev.tfvars`),
insert the following and fill in the respective values that suit your project:
```
rcon_password = ""
whitelist_url = ""
server_name = ""
server_motd = ""
mods = ""
spiget = ""
ops = ""
```

## Apply changes to prod
Run `./apply-prod.sh` or `terraform apply -var-file="{filename}.tfvars"`