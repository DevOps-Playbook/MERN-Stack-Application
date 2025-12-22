provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.name]
  }
}

resource "kubernetes_service_v1" "mern_service" {
  metadata {
    name = "mern-service"
  }
  spec {
    selector = {
      app = "mern-app" # Ensure matches your Deployment
    }
    port {
      port        = 80   # Port exposed internally
      target_port = 3000 # Port your container listens on
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "mern_alb" {
  metadata {
    name = "mern-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.mern_service.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.lb_controller]
}

output "alb_hostname" {
  value = try(
    kubernetes_ingress_v1.mern_alb.status.0.load_balancer.0.ingress.0.hostname,
    "Load Balancer is active. Run 'kubectl get ingress' to see the URL."
  )
}
