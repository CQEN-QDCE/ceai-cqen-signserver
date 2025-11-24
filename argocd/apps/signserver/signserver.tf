################################################################################
# Déploiement d'une application Signserver via ArgoCD
################################################################################

resource "kubernetes_manifest" "signserver_app_of_apps" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "signserver-${terraform.workspace}"
      namespace = "argocd"
      labels = {
        "app.kubernetes.io/name"    = "signserver-${terraform.workspace}"
        "app.kubernetes.io/part-of" = "xroad-${terraform.workspace}"
      }
    }
    spec = {
      project = "base"
      source = {
        repoURL        = var.repo_github_url
        targetRevision = var.target_revision
        path           = var.chart_path
        helm = {
          values = yamlencode({
            signserver_image   = var.signserver_image
            signserver_tag = var.signserver_tag
            # ingressIcp = {
            #   annotations = {
            #     subnetAllowList   = "${module.sea_network.web_subnet_a.id}, ${module.sea_network.web_subnet_b.id}"
            #     acmCertificateArn = var.acm_certificate_arn
            #   }
            #}
            serviceExt = {
              annotations = {
                subnetAllowList   = "${module.sea_network.web_subnet_a.id}, ${module.sea_network.web_subnet_b.id}"
                acmCertificateArn = var.acm_certificate_arn
              }
            }
            ejbca = {
              env = {
                DATABASE_JDBC_URL = var.DATABASE_JDBC_URL
                DATABASE_USER     = var.DATABASE_USER
                DATABASE_PASSWORD = var.DATABASE_PASSWORD
              }
            }
          })
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "base"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  } 
}

