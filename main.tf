provider "aws" {
  region = "us-east-1"  # Altere conforme sua região desejada
}

# Recurso para o grupo de log do CloudWatch
resource "aws_cloudwatch_log_group" "log_state_machine_produto_credito" {
  name              = "log_state_machine_produto_credito"
  retention_in_days = 14
}

# Recurso para a State Machine
resource "aws_sfn_state_machine" "produto_credito_state_machine" {
  name     = "produto_credito_state_machine"
  role_arn = join(":",["arn:aws:iam:", data.aws_caller_identity.current.account_id, var.sf_role])
  definition = jsonencode(jsondecode(file("./app/stepfunctions/state_machine_produto_credito.json")))

  tags = {
    DMA = "DataMeshAcademy"
  }
  
  logging_configuration {
    level    = "ALL"
    include_execution_data = true
    log_destination = "${aws_cloudwatch_log_group.log_state_machine_produto_credito.arn}:*"
  }
}

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


