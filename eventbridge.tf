# Recurso para a regra de evento do Eventbridge
resource "aws_cloudwatch_event_rule" "produto_credito_eventbridge_rodolfo" {
  name                = "produto_credito_eventbridge_rodolfo"
  description = "Agendamento para execução mensal do produto de crédito"
  schedule_expression = "cron(0 21 23 * ? *)"  # Executar todo dia 23 de todos os meses às 18 horas
  tags = {
    DMA = "DataMeshAcademy"
  }
}

# Amarrando a step function a regra
resource "aws_cloudwatch_event_target" "target_produto_credito_rodolfo" {
    rule = aws_cloudwatch_event_rule.produto_credito_eventbridge_rodolfo.name
    arn = aws_sfn_state_machine.produto_credito_state_machine_rodolfo.arn
  role_arn = join(":",["arn:aws:iam:", data.aws_caller_identity.current.account_id, var.eventbridge_role])
}