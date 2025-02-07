[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/Jkl9jCdw)\

# First project

## Guide to run the code

You can run `report.Rmd`, which will automatically execute all scripts sequentially and render the pdf.

Alternatively, you can re-run the analysis on your own.\
In the **data** folder you will find the raw datasets and the `preprocessing.R` script, that generates a processed dataset. From this one, three more datasets utilized during our analysis are created in other files, and they are all stored in the **NEW_DATASET** folder.

Afterwards, you can execute the following scripts in this order: `cost.R`, `violin.R`, `salary.R`, `east_west.R`, `barplots.R`, `university.R`, and `goodness_vs_happiness.R`. Each of these files will produce a corresponding plot.

------------------------------------------------------------------------

The goal of this project is data exploration. Find an interesting (in the sense it interests you!) data set and

-   lay out some questions about the data
-   describe the data
-   explore the data
-   visualize the data
-   use more detailed visualization techniques to hint answers

These steps correspond to the first three stages of the [data science life cycle](https://vdsbook.com/02-dslc.html).

Note that the purpose of this project is to play around, demonstrating your data exploration, wrangling and visualization skills. Hopefully, you will also find scientifically interesting questions or questions of personal interest, e.g., does ball possession matters in a game of football? Is there a link between the GDP of a country and its contribution to global warming? Try though to avoid Kaggle data sets that have been analyzed zillion times before.

[Here is an example of what your report could look like](https://math-517.github.io/math_517_website/projects/mini_project_example.html). See [this page for some tips and resources](https://math-517.github.io/math_517_website/projects/project-tips-resources.html) (e.g., example datasets).

#### Submission

Write a **PDF report** explaining your findings **max 10 pages**.

If using Quarto, use the `report.qmd` file to write your report [^readme-1]. Alternatively, any other format that produces a pdf file is fine (e.g., Rmarkdown), as long as the code is well commented and made available too.

[^readme-1]: `.qmd` files are [Quarto](https://quarto.org/) files, which can be used to write markdown report with R, Julia and Python (sometimes simultaneously).

The report should be self-contained and **we should have access to all code necessary to reproduce your results** (for help with virtual environments, see [this page](https://math-517.github.io/math_517_website/resources/tips/virtual_environments.html)).
