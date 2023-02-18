terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "0.0.20"
    }
  }
}

provider "fly" {
}

variable "rcon_password" {
  type = string
}

variable "whitelist_url" {
  type = string
}

variable "server_name" {
  type = string
}

variable "server_motd" {
  type = string
}

variable "server_memory" {
  type = string
}

variable "mods" {
  type = string
}

variable "spiget" {
  type = string
}

variable "ops" {
  type = string
}

resource "fly_app" "cozycraft" {
  name = "cozycraft"
  org  = "personal"
}

resource "fly_volume" "cozycraftStorage" {
  app    = "cozycraft"
  name   = "cozycraftStorage"
  size   = 15
  region = "yyz"

  depends_on = [
    fly_app.cozycraft
  ]
}

resource "fly_ip" "cozycraftIP" {
  app  = "cozycraft"
  type = "v4"

  depends_on = [
    fly_app.cozycraft
  ]
}

resource "fly_machine" "cozycraftServer" {
  name   = "cozycraftServer"
  region = "yyz"
  app    = "cozycraft"
  image  = "itzg/minecraft-server:latest"

  env = {
    EULA                    = "TRUE"
    ENABLE_AUTOSTOP         = "TRUE"
    AUTOSTOP_TIMEOUT_EST    = 120
    AUTOSTOP_TIMEOUT_INIT   = 120
    MEMORY                  = "12G"
    AUTOSTOP_PKILL_USE_SUDO = "TRUE"
    MAX_WORLD_SIZE          = 16000000
    TYPE                    = "PAPER"
    ENFORCE_WHITELIST       = "TRUE"
    WHITELIST_FILE          = var.whitelist_url
    OVERRIDE_WHITELIST      = "TRUE"
    OPS                     = var.ops
    OVERRIDE_OPS            = "TRUE"
    SERVER_NAME             = var.server_name
    SPAWN_PROTECTION        = 0
    VIEW_DISTANCE           = 15
    DIFFICULTY              = "normal"
    ENABLE_COMMAND_BLOCK    = "true"
    SPIGET_RESOURCES        = var.spiget
    RCON_PASSWORD           = var.rcon_password
    MOTD                    = var.server_motd
    MODS                    = var.mods
  }

  services = [
    {
      ports = [
        {
          port = 25565
        }
      ]
      protocol      = "tcp"
      internal_port = 25565
    },
    {
      ports = [
        {
          port = 25575
        }
      ]
      protocol      = "tcp"
      internal_port = 25575
    },
    # {
    #   ports = [
    #     {
    #       port = 8100
    #     }
    #   ]
    #   protocol      = "tcp"
    #   internal_port = 8100
    # },
    # https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v3.10/BlueMap-3.10-spigot.jar,
    {
      ports = [
        {
          port = 19132
        }
      ]
      protocol      = "udp"
      internal_port = 19132
    }
  ]

  mounts = [
    {
      path   = "/data"
      volume = fly_volume.cozycraftStorage.id
    }
  ]

  cpus     = 8
  memorymb = 16384

  depends_on = [
    fly_volume.cozycraftStorage,
    fly_app.cozycraft
  ]
}
