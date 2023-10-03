
module "ecr" {
  source = "./modules/ecr"
}

module "ecs_task_definition" {
  source = "./modules/ecs_task_definition"
}



module "ecs" {
  source = "./modules/ecs"
  ecs_task_definition=module.ecs_task_definition.ecs_task_definition
}
