### API

resource "heroku_app" "api_production" {
  name   = "${var.heroku_team_name}-api-production"
  region = "us"
  acm    = true

  organization = {
    name = "${var.heroku_team_name}"
  }
}

resource "heroku_addon" "papertrail_ui_production" {
  app  = "${heroku_app.api_production.name}"
  plan = "papertrail:choklad"
}

resource "heroku_pipeline_coupling" "api_production" {
  app      = "${heroku_app.api_production.name}"
  pipeline = "${heroku_pipeline.api.id}"
  stage    = "production"
}

resource "heroku_app_release" "api_production" {
  app     = "${heroku_app.api_production.name}"
  slug_id = "${var.api_slug_production}"
}

resource "heroku_formation" "api_production" {
  app        = "${heroku_app.api_production.name}"
  type       = "web"
  quantity   = 2
  size       = "standard-1x"
  depends_on = ["heroku_app_release.api_production"]
}

### UI

resource "heroku_app" "ui_production" {
  name   = "${var.heroku_team_name}-ui-production"
  region = "us"
  acm    = true

  organization = {
    name = "${var.heroku_team_name}"
  }

  config_vars = {
    API_URL = "https://${var.api_host_name}"
  }
}

resource "heroku_addon" "papertrail_api_production" {
  app  = "${heroku_app.ui_production.name}"
  plan = "papertrail:choklad"
}

resource "heroku_pipeline_coupling" "ui_production" {
  app      = "${heroku_app.ui_production.name}"
  pipeline = "${heroku_pipeline.ui.id}"
  stage    = "production"
}

resource "heroku_app_release" "ui_production" {
  app     = "${heroku_app.ui_production.name}"
  slug_id = "${var.ui_slug_production}"
}

resource "heroku_formation" "ui_production" {
  app        = "${heroku_app.ui_production.name}"
  type       = "web"
  quantity   = 2
  size       = "standard-1x"
  depends_on = ["heroku_app_release.ui_production"]
}