# Recurso para a regra de evento do Eventbridge
resource "aws_cloudwatch_event_rule" "produto_credito_eventbridge" {
  name                = "produto_credito_eventbridge"
  description = "Agendamento para execução mensal do produto de crédito"
  schedule_expression = "cron(0 14 5 * ? *)"  # Executar todo dia 05 de todos os meses às 14 horas
}

# Amarrando a step function a regra
resource "aws_cloudwatch_event_target" "target_produto_credito" {
    rule = aws_cloudwatch_event_rule.produto_credito_eventbridge.name
    arn = aws_sfn_state_machine.produto_credito_state_machine.arn
  role_arn = join(":",["arn:aws:iam:", data.aws_caller_identity.current.account_id, var.eventbridge_role])
}