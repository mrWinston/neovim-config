local abbreviation_path = vim.fn.stdpath("config") .. "/abbreviations.json"

local file = io.open(abbreviation_path, "rb") -- r read mode and b binary mode
if not file then
  return {}
end
local content = file:read("*a") -- *a or *all reads the whole file
file:close()

local all_abbreviations = vim.json.decode(content)
local custom_abbrev = {
  ALB = "Application Load Balancer",
  AAO = "AWS Account Operator",
  AAS = "AWS Account Shredder",
  CIO = "Cloud Ingress Operator",
  CVO = "Cluster Version Operator",
  HCP = "Hosted Control Plane",
  MC = "Management Cluster",
  MCC = "Managed Cluster Context",
  MUO = "Mananged Upgrade Operator",
  MNMO = "Managed Node Metadata Operator",
  NLB = "Network Load Balancer",
  RMO = "Route Monitor Operator",
  SD = "Service Delivery",
  SOP = "Standard Operating Procedure",
  OBO = "Observability Operator",
  DP = "Data Plane",
  DPA = "DataProtectionApplication",
  KAS = "Kube API Server",
  CAPI= "Cloud API",
}

for k,v in pairs(custom_abbrev) do all_abbreviations[k] = v end

return all_abbreviations
