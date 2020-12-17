# Packages
library(pacman)
pacman::p_load(readr, data.table, dplyr, tidyjson, janitor, tidyr, reshape2, ggplot2, scales)

# Constants
raw_dir <- './_raw_data/'
clean_dir <- './_clean_data/'
metrics_names <- c(
  # 'orders',
  # 'routes',
  # 'couriers',
  # 'variables',
  # 'constraints',
  # 'routing_time',
  # 'matching_time'
  'click_to_door_time',
  'drop_off_lateness_time',
  'ready_to_pick_up_time',
  'click_to_taken_time',
  'in_store_to_pick_up_time',
  'dropped_off',
  'click_to_cancel_time'
)
keyword <- 'order_metrics' #'matching_optimization_metrics'
scenarios_list <- list(
  '0_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 1,
  '1_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 2,
  '2_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 3,
  '6_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 4,
  '7_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 5,
  '8_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 6,
  '12_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 7,
  '13_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 8,
  '14_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 9,
  '18_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 10,
  '19_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 11,
  '20_10:00:00_18:00:00_16:00:00_16:05:00_10:00:00_10:10:00_18000_25_15' = 12,
  '3_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 13,
  '4_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 14,
  '9_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 15,
  '10_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 16,
  '15_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 17,
  '16_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 18,
  '21_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 19,
  '22_00:00:00_23:59:59_00:00:00_22:00:00_00:00:00_06:00:00_10800_25_15' = 20,
  '3_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 21,
  '4_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 22,
  '9_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 23,
  '10_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 24,
  '15_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 25,
  '16_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 26,
  '21_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 27,
  '23_07:00:00_12:00:00_07:00:00_11:00:00_07:00:00_09:00:00_3600_60_45' = 28,
  '5_00:00:00_10:00:00_00:00:00_08:00:00_00:00:00_00:10:00_8400_60_45' = 29,
  '11_00:00:00_10:00:00_00:00:00_08:00:00_00:00:00_00:10:00_8400_60_45' = 30,
  '17_00:00:00_10:00:00_00:00:00_08:00:00_00:00:00_00:10:00_8400_60_45' = 31,
  '22_00:00:00_10:00:00_00:00:00_08:00:00_00:00:00_00:10:00_8400_60_45' = 32,
  '5_08:00:00_21:00:00_19:00:00_19:05:00_08:00:00_08:30:00_18000_50_30' = 33,
  '11_08:00:00_21:00:00_19:00:00_19:05:00_08:00:00_08:30:00_18000_50_30' = 34,
  '17_08:00:00_21:00:00_19:00:00_19:05:00_08:00:00_08:30:00_18000_50_30' = 35,
  '22_08:00:00_21:00:00_19:00:00_19:05:00_08:00:00_08:30:00_18000_50_30' = 36
)

# Raw data
files <- list.files(path = raw_dir, pattern = paste0('*', keyword, '*'))
temp <- lapply(paste0(raw_dir, files), read_csv)
data <- dplyr::bind_rows(temp)

# Process data
raw_metrics <- data %>% 
  bind_cols(
    spread_all(data$simulation_settings) %>% 
      as_tibble %>% 
      clean_names %>% 
      select(-document_id)
  ) %>% 
  bind_cols(
    spread_all(data$simulation_policies) %>% 
      as_tibble %>% 
      clean_names %>% 
      select(-document_id)
  ) %>% 
  bind_cols(
    spread_all(data$extra_settings) %>% 
      as_tibble %>% 
      clean_names %>% 
      select(-document_id)
  ) %>% 
  mutate(
    operation_policies = paste0(courier_acceptance_policy, '_', courier_movement_evaluation_policy),
    simulation_config = paste0(
      instance_id, '_',
      simulate_from, '_', 
      simulate_until, '_',
      create_users_from, '_',
      create_users_until, '_', 
      create_couriers_from, '_',
      create_couriers_until, '_',
      warm_up_time, '_',
      dispatcher_wait_to_cancel / 60, '_',
      user_wait_to_cancel / 60
    ),
    matching_policy = dispatcher_matching_policy,
    instance_id = instance_id
  ) %>% 
  dplyr::filter(!(simulate_from == '00:00:00' & simulate_until == '23:59:59' & computer == 'macbook_air')) %>%
  mutate(
    scenario = as.numeric(scenarios_list[simulation_config])
  ) %>%
  select(
    operation_policies, matching_policy, scenario, computer,
    all_of(metrics_names)
  )

if (keyword == 'order_metrics') {
  order_metrics <- raw_metrics %>% 
    mutate(
      click_door = click_to_door_time,
      lateness = drop_off_lateness_time,
      ready_pick = ready_to_pick_up_time,
      click_take = click_to_taken_time,
      store_pick = in_store_to_pick_up_time
    ) %>% 
    select(
      -c(
        'click_to_door_time',
        'drop_off_lateness_time',
        'ready_to_pick_up_time',
        'click_to_taken_time',
        'in_store_to_pick_up_time'
      )
    )
  metrics_long_dropped_off <- order_metrics %>% 
    dplyr::filter(dropped_off) %>% 
    select(-c(dropped_off, click_to_cancel_time)) %>% 
    melt(
      id.vars = c('operation_policies', 'matching_policy', 'scenario', 'computer'),
      variable.name = 'metric',
      value.name = 'value'
    )
  metrics_long_canceled <- raw_metrics %>% 
    dplyr::filter(!dropped_off) %>% 
    select(
      operation_policies, matching_policy, scenario, computer, click_to_cancel_time
    ) %>% 
    melt(
      id.vars = c('operation_policies', 'matching_policy', 'scenario', 'computer'),
      variable.name = 'metric',
      value.name = 'value'
    )
  
  # Finalize and save data
  metrics_long_dropped_off %>% write_csv(paste0(clean_dir, 'clean_dropped_off_', keyword, '.csv'))
  metrics_long_canceled %>% write_csv(paste0(clean_dir, 'clean_canceled_', keyword, '.csv'))
} else{
  metrics_long <- raw_metrics %>% 
    melt(
      id.vars = c('operation_policies', 'matching_policy', 'scenario', 'computer'),
      variable.name = 'metric',
      value.name = 'value'
    )
  
  # Finalize and save data
  metrics_long %>% write_csv(paste0(clean_dir, 'clean_', keyword, '.csv'))
  raw_metrics %>% write_csv(paste0(clean_dir, 'clean_wide_', keyword, '.csv'))
}




