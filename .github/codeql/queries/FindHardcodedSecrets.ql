/**
 * @name Find hardcoded secrets in C#
 * @description Detects hardcoded string literals assigned to fields with secret-related names
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.0
 * @id cs/hardcoded-secrets
 * @tags security
 */

import csharp

predicate isSecretField(Field f) {
  f.getName().regexpMatch("(?i).*(apiKey|token|secret|password|auth)")
}

predicate isSecretValue(string_literal s) {
  s.getValue().regexpMatch("(?i)^(sk_.*|token_.*|apikey_.*|[a-zA-Z0-9+/=]{32,})")
}

from Field f, string_literal s
where
  isSecretField(f) and
  f.getInitializer() = s and
  isSecretValue(s)
select s, "Hardcoded secret detected: '" + s.getValue() + "' assigned to field '" + f.getName() + "'"
