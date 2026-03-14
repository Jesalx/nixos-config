---
paths:
  - "**/*.tf"
  - "**/*.tfvars"
---

# Terraform Preferences

Write clear, explicit Terraform. Favour readability and safe changes over DRY.

## Structure

- Standard file split: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`.
- `snake_case` for all names. Don't repeat the resource type in the name.
- Pin provider versions with `~>`: `version = "~> 5.0"`.

## Variables & Outputs

- Every variable and output needs a `description` and explicit `type`.
- Use `sensitive = true` for secrets. Never hardcode credentials.
- Prefer data sources over hardcoded IDs or ARNs.

## Resources

- Use `lifecycle { prevent_destroy = true }` on stateful resources (databases, buckets).
- Only use `lifecycle { ignore_changes }` with a comment explaining why.
- Only use `depends_on` when Terraform can't infer the dependency; comment why.

## Tooling

- Code must pass `terraform fmt` and `terraform validate`.
- Run `tflint` on changed files.
