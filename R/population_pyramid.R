population_pyramid <- function(location, year) {
  data=readRDS(here::here("data","population_age_and_sex_data.rds")) |>
    dplyr::filter(sex != 'Both sexes' & variant == 'Median') |>
    dplyr::select(sex,ageStart,value,source,variant) |>
    dplyr::mutate(ageGroup=if_else(ageStart==100,100,trunc(ageStart/5)*5)) |>
    dplyr::mutate(total_population=sum(value)) |>
    dplyr::group_by(locationId,location,iso3,iso2,
             sexId,sex,ageGroup,timeLabel,source,variant,total_population,value) |>
    dplyr::summarise(sexage_population=sum(value),.groups='drop') |>
    dplyr::ungroup() |>
    dplyr::mutate(sexage_population=if_else(sex=='Male',-sexage_population,sexage_population),
                  relative_population=sexage_population/total_population) |>
    dplyr::mutate(ageGroup_f=factor(ageGroup,levels=unique(ageGroup),
                                    ordered=TRUE))

  gg=ggplot2::ggplot(data=data,aes(x=ageGroup_f,y=relative_population,group=sex,fill=sex))+
    ggplot2::geom_bar(stat='identity')+
    ggplot2::coord_flip()+
    ggplot2::labs(caption = "Source: United Nations. World Population Prospects 2022",
         title=paste0('Pirâmide Etária: ',location),
         subtitle=year)+
    ggplot2::scale_y_continuous(name='População (%)',
                       labels=scales::label_percent(big.mark = '.',decimal.mark = ','),
                       breaks = seq(-.16,.16,.04))+
    ggplot2::scale_fill_manual(name='Sex',label=c('Male','Female'),values=c('lightpink','lightblue'))+
    ggplot2::scale_x_discrete(name='Grupo de Idade')+
    ggplot2::theme_minimal()
  return(gg)
}
