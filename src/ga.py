import pandas as pd
import numpy as np
import random
import time
from deap import base
from deap import creator
from deap import tools

agents_table = pd.DataFrame.from_records([
    ['Agent 0', 4, 4, 9, 1, 0, 23],
    ['Agent 1', 2, 4, 4, 1, 0, 10],
    ['Agent 2', 8, 3, 9, 26, 35, 85],
    ['Agent 3', 3, 1, 4, 8, 4, 11],
    ['Agent 4', 9, 3, 6, 7, 6, 20],
    ['Agent 5', 0, 3, 8, 7, 6, 20],
])
agents_table.columns = ['Name', 'K0', 'K1', 'K2', 'K3', 'K4', 'K5']

tasks_table = pd.DataFrame.from_records([
    ['Task 0', 4, 4, 9, 1, 0, 23],
    ['Task 1', 2, 4, 4, 1, 0, 10],
    ['Task 2', 8, 3, 9, 26, 35, 85],
    ['Task 3', 3, 1, 4, 8, 4, 11],
    ['Task 4', 9, 3, 6, 7, 6, 20],
    ['Task 5', 9, 3, 6, 7, 6, 20],
    ['Task 6', 9, 3, 6, 7, 6, 20],
    ['Task 7', 9, 3, 6, 7, 6, 20],
    ['Task 8', 9, 3, 6, 7, 6, 20],
    ['Task 9', 9, 3, 6, 7, 6, 20],
    ['Task 10', 0, 3, 8, 7, 6, 20],
])
tasks_table.columns = ['Name', 'R0', 'R1', 'R2', 'R3', 'R4', 'R5']


def chromosome():
    return random.choices(range(0, len(agents_table)), k=len(tasks_table))


def evaluate(individual):
    individual = individual[0]
    result_list = []
    for i in range(len(individual)):
        agent_skills = list(agents_table.iloc[individual[i], 1:agents_table.shape[1]])
        skills_required = list(tasks_table.iloc[individual[i], 1:tasks_table.shape[1]])
        result_list.append(
            round(np.var(
                [x + y for x, y in zip(agent_skills, skills_required)]))
        )
    return result_list


def find_best_individual(toolbox):
    pop = toolbox.population(n=300)

    # Evaluate the entire population
    fitnesses = list(map(toolbox.evaluate, pop))
    for ind, fit in zip(pop, fitnesses):
        ind.fitness.values = fit

    # CXPB  is the probability with which two individuals
    #       are crossed
    #
    # MUTPB is the probability for mutating an individual
    CXPB, MUTPB = 0.5, 0.2

    # Extracting all the fitnesses of
    fits = [ind.fitness.values[0] for ind in pop]

    # Variable keeping track of the number of generations
    g = 0

    # Begin the evolution
    while g < 50:
        # A new generation
        g = g + 1
        # print("-- Generation %i --" % g)

        # Select the next generation individuals
        offspring = toolbox.select(pop, len(pop))
        # Clone the selected individuals
        offspring = list(map(toolbox.clone, offspring))

        # Apply crossover and mutation on the offspring
        for child1, child2 in zip(offspring[::2], offspring[1::2]):
            if random.random() < CXPB:
                toolbox.mate(child1[0], child2[0])
                del child1.fitness.values
                del child2.fitness.values

        for mutant in offspring:
            if random.random() < MUTPB:
                toolbox.mutate(mutant[0])
                del mutant.fitness.values

        # Evaluate the individuals with an invalid fitness
        invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
        fitnesses = map(toolbox.evaluate, invalid_ind)
        for ind, fit in zip(invalid_ind, fitnesses):
            ind.fitness.values = fit

        pop[:] = offspring

        # Gather all the fitnesses in one list and print the stats
        fits = [ind.fitness.values[0] for ind in pop]

        length = len(pop)
        mean = sum(fits) / length
        sum2 = sum(x * x for x in fits)
        std = abs(sum2 / length - mean ** 2) ** 0.5

    best = pop[np.argmin([toolbox.evaluate(x) for x in pop])]
    return best


def main():
    return [0, 0, 1, 1, 2]
    creator.create("FitnessMin", base.Fitness, weights=(-1.0,))
    creator.create("Individual", list, fitness=creator.FitnessMin)

    toolbox = base.Toolbox()

    toolbox.register("chromosome", chromosome)
    toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.chromosome, n=1)
    toolbox.register("population", tools.initRepeat, list, toolbox.individual)

    toolbox.register("evaluate", evaluate)
    toolbox.register("mate", tools.cxTwoPoint)
    toolbox.register("mutate", tools.mutFlipBit, indpb=0.05)
    toolbox.register("select", tools.selTournament, tournsize=3)

    best_solution = find_best_individual(toolbox)
    print(best_solution[0])
    return best_solution[0]


if __name__ == '__main__':
    start = time.time()
    # main()
    end = time.time()
    print(f"Runtime of the program is {end - start}")
