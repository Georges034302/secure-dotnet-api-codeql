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

predicate isSecretValue(string value) {
  value.regexpMatch("(?i)^(sk_.*|token_.*|apikey_.*|[a-zA-Z0-9+/=]{32,})")
}

from Field f, StringLiteral lit
where
  isSecretField(f) and
  f.getInitializer() = lit and
  isSecretValue(lit.getValue())
select lit, "Hardcoded secret detected: '" + lit.getValue() + "' assigned to field '" + f.getName() + "'"
from Field f, StringLiteral lit
where
  isSecretField(f) and
  f.getInitializer() = lit and
  isSecretValue(lit.getValue())
select lit, "Hardcoded secret detected: '" + lit.getValue() + "' assigned to field '" + f.getName() + "'"