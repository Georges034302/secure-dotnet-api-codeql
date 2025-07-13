/**
 * @name Hardcoded secrets in C# code
 * @description Finds string literals that may contain hardcoded secrets.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.0
 * @id cs/hardcoded-secrets
 * @tags security, external/cwe/cwe-798
 */

import csharp

from StringLiteral s
where
  s.getValue().regexpMatch("(?i)(sk_[a-z0-9]{10,}|api[_-]?key|token|secret|[A-Za-z0-9+/=]{32,})")
select s, "🔒 Possible hardcoded secret: '" + s.getValue() + "'"
