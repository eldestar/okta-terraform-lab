# okta-terraform-lab

A small Terraform project that manages a slice of an Okta tenant as code:
a group, a dynamic group rule, an OAuth app, and a sign-on policy with a rule.
It is a lab for learning the workflow, not a production setup.

What is in it:

| Resource | Where |
| --- | --- |
| Group, and a group rule that adds users whose `department` is `Engineering` | `terraform/modules/groups` |
| OAuth web app (authorization code) assigned to that group | `terraform/modules/apps` |
| Sign-on policy for the group, with a rule that requires MFA | `terraform/modules/policies` |
| Optional S3 remote state (example files only) | `terraform/backend.tf.example`, `backend.hcl.example` |
| Credential-free CI check: `fmt`, `init -backend=false`, `validate` | `.github/workflows/validate.yml` |
| Plan on pull request, approved apply on merge (off until enabled) | `.github/workflows/okta-terraform.yml` |

## What has and has not been checked

- `terraform fmt -check`, `terraform init -backend=false` and `terraform validate`
  pass (Terraform 1.16.5, `okta/okta` provider `~> 7.0`; the lock file is committed
  for linux and macOS on amd64 and arm64).
- `terraform plan` and `apply` have **not** been run against a live Okta org for
  this revision, and the plan/apply workflow has not run in GitHub Actions. Treat
  the resource arguments as unverified against a live tenant until you have planned
  them yourself.
- The sign-on policy uses `okta_policy_signon`. If your org is on Identity
  Engine, check the provider documentation for the policy resources your org
  needs before relying on this one.
- This does not describe any production environment, and nothing here is a
  claim about how a real organisation runs Okta.

## Run it against a developer org

You need an Okta developer org, Terraform 1.7 or newer, and an API token
(**Security > API > Tokens**). Credentials come from the environment only:

```bash
export OKTA_ORG_NAME="dev-XXXXXXX"
export OKTA_BASE_URL="okta.com"
export OKTA_API_TOKEN="..."          # never in a file

cd terraform
cp terraform.tfvars.example terraform.tfvars   # optional; git-ignored
terraform init
terraform plan                                  # read it before applying
terraform apply
terraform destroy                               # when you are done
```

State stays in a local file unless you add a backend. For a team, use remote
state: copy `backend.tf.example` to `backend.tf`, copy `backend.hcl.example` to
`backend.hcl`, fill it in, and run `terraform init -backend-config=backend.hcl`.
The bucket and lock table must exist first; Terraform cannot create the backend
it stores its own state in. The example uses a DynamoDB lock table; check the
current S3 backend documentation, because locking options have changed over time.

## CI

`validate.yml` runs on every push and pull request with no credentials.

`okta-terraform.yml` is skipped until you set the repository variable
`OKTA_CI` to `true`. It then plans on pull requests and applies on merge to
`main` inside an environment named `okta-dev` (add required reviewers to that
environment). It needs the secrets `OKTA_ORG_NAME`, `OKTA_BASE_URL`,
`OKTA_API_TOKEN`, `AWS_ROLE_ARN`, and the variable `TF_STATE_BUCKET`. Point it at
a developer org only.

## Scaling notes

These are things to think about as a tenant grows, not measurements from this lab.

- **State splitting.** One state file for everything makes each plan slower and
  widens the blast radius of a bad apply. Splitting by domain (groups and rules,
  apps, policies) or by environment limits both, at the cost of cross-state
  references. The backend key already carries the environment in the example.
- **API rate limits.** Okta rate-limits management APIs, and Terraform refreshes
  every resource on each plan. Large states can hit those limits; lower
  parallelism (`-parallelism`) and splitting state are the usual levers. Check the
  current Okta rate-limit documentation for your org's numbers.
- **Plan time.** Refresh time grows with the number of resources and remote
  calls. `-refresh=false` and targeted plans save time but can hide drift.
- **Apply review.** The apply job re-plans after the approval gate, so the
  approver is not looking at the exact plan that runs. A stricter setup saves the
  reviewed plan from the pull request and applies that artifact.
- **Imports and drift.** Existing objects need `terraform import` before
  Terraform will manage them, and changes made in the admin console show up as
  drift on the next plan.

## License

MIT, see `LICENSE`.
