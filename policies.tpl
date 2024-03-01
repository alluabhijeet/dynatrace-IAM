---
policies:
{{- range .Teams }}
  - name: Policy for {{ .name }}
    id: policy-{{ .name }}
    level:
      type: account
    description: Policy for managing settings for team {{ .name }}
    policy: |-
      {{ $.Permission }}
      WHERE environment:management-zone IN ({{ range $index, $zone := .ManagementZone }}"{{ $zone }}"{{if lt $index (sub (len .ManagementZone) 1)}}, {{end}}{{end}});
{{- end }}
