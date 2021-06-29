import numpy as np
import random
import time
from deap import base
from deap import creator
from deap import tools
from numpy.random import seed
from numpy.random import randint
import time

np_task_table = np.array([])
np_agents_table = np.array([])
np_repository = np.array([])


# np.random.seed(32)

# np_agents_table = np.random.rand(5, 6)
# np_task_table = np.random.randint(10, 3)
# np_repository = np.array([])

# 0 - Weight's Task
# 1 - Knowledge list
# 2 - File
# np_agents_table = np.array([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
# np_task_table = np.array([[1, 0, 1], [1, 1, 1], [1, 2, 0]])
# np_repository = np.array([[1, 0, 0], [0, 1, 0], [0, 0, 1]])


# np_agents_table = np.array([[10, 11], [11, 12]])
# np_task_table = np.array([[10, 0, 999], [10, 1, 999]])


# np_agents_table = np.array([[4, 2, 1], [1, 1, 1], [1, 0, 1]])
# np_task_table = np.array([[1, 2, 4], [0, 1, 0]])

# np_agents_table = np.array([[10, 0, 0, 1], [10, 5, 5, 6], [0, 10, 5, 4]])
# np_task_table = np.array([[1, 2, 4], [0, 1, 0]])

def calculate_doa(repository):
    doa = np.zeros(dtype=int, shape=(repository.shape[0], repository.shape[1]))

    index = 0
    for i in repository:
        doa[index, np.argmax(i, axis=0)] = 1
        index += 1
    return doa


def removeTopOfAuthors(a):
    authors_contributions = np.sum(a, axis=0)
    author = np.argmax(authors_contributions, axis=0)
    a = np.delete(a, author, 1)
    return a


def getCoverage(n_files, authors_mapped):
    return np.sum(authors_mapped) / n_files


def calculate_truck_factor(rep_mapped, n_files, n_developers):
    files_size = n_files
    tf = 0
    for i in range(n_developers):
        coverage = getCoverage(files_size, rep_mapped)
        if coverage < 0.5:
            break
        rep_mapped = removeTopOfAuthors(rep_mapped)
        tf += 1
    return tf


def start_tf(repository):
    repository = np.array(repository)
    rep_mapped = calculate_doa(repository)
    return calculate_truck_factor(rep_mapped, repository.shape[0], repository.shape[1])


def chromosome():
    return random.choices(range(0, len(np_agents_table)), k=len(np_task_table))


def evaluate(individual):
    individual = individual[0]
    result_list = []
    for i in range(len(individual)):
        agent_skills = list(np_agents_table[individual[i]])
        skills_required = list(np_task_table[i])
        # result_list.append(
        #    round(np.var([x + y for x, y in zip(agent_skills, skills_required)]))
        # )

        np_list = []

        for j in range(len(agent_skills)):
            np_list.append(agent_skills[j] + skills_required[j])

        # result_list.append(round(np.var(np_list)))
        result_list.append(np.var(np_list))

    hist, bins = np.histogram(individual, bins=np.arange(np_agents_table.shape[1] + 1))

    note_1 = np.mean(result_list)
    note_2 = np.var(hist)
    # print(note_1)
    return [note_1 + note_2]


def evaluate2(individual):
    individual = individual[0]
    result_list = []
    for i in range(len(individual)):
        agent_skills = list(np_agents_table[individual[i]])
        skills_required = list(np_task_table[i])
        task_level_required = skills_required[0]
        task_knowledge = skills_required[1]
        task_file = skills_required[2]
        agent_skills[task_knowledge] = agent_skills[task_knowledge] + task_level_required
        result_list.append(np.var(agent_skills))

    hist, bins = np.histogram(individual, bins=np.arange(np_agents_table.shape[1] + 1))

    note_1 = np.mean(result_list)
    note_2 = np.var(hist)
    # print(note_1)
    return [note_1 + note_2]


def evaluate3(individual):
    individual = individual[0]
    for i in range(len(individual)):
        agent = individual[i]
        skills_required = list(np_task_table[i])
        task_level_required = skills_required[0]
        task_file = skills_required[2]
        np_repository[task_file][agent] = np_repository[task_file][agent] + task_level_required

    truck_factor = start_tf(np_repository)

    hist, bins = np.histogram(individual, bins=np.arange(np_agents_table.shape[1] + 1))
    note_2 = np.var(hist)
    # print(truck_factor - note_2)
    return [truck_factor]


def evaluate4(individual):
    individual = individual[0]
    for i in range(len(individual)):
        agent = individual[i]
        skills_required = list(np_task_table[i])
        task_level_required = skills_required[0]
        task_file = skills_required[2]
        np_repository[task_file][agent] = np_repository[task_file][agent] + task_level_required

    variance_total = 0

    for i in np_repository:
        variance_total += np.var(i)

    return [variance_total]


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
    CXPB, MUTPB = 0.1, 0.1

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

    best = pop[np.argmax([toolbox.evaluate(x) for x in pop])]
    return best


# Adicionar mecanismo de maximo de tarefas para o agente e assim fazer com que escolha o segundo mais indicado.
def best_agent_skill():
    individual = []
    for i in range(len(np_task_table)):
        task = list(np_task_table[i])
        task_level_required = task[0]
        knowledge_skill = task[1]
        best_agent_index = np_agents_table[:, knowledge_skill].argmax()
        np_agents_table[best_agent_index, knowledge_skill] += task_level_required
        individual.append(best_agent_index)

    return individual


def evaluate_repository(repository):
    for i in np.array(repository):
        time.sleep(1)
        print("AVG: {} VAR: {} MAX: {} MIN: {}".format(round(np.average(i), 2), round(np.var(i), 2), np.max(i),
                                                       np.min(i)))


def main(repository, a_table, t_table, type):
    global np_agents_table
    global np_task_table
    global np_repository

    np_agents_table = np.array(a_table)
    np_task_table = np.array(t_table)
    np_repository = np.array(repository)

    if type == 'data/random.txt':
        np.random.seed(32)
        values = randint(0, np_agents_table.shape[0], np_task_table.shape[0])
        return values
        return random.shuffle(values)

    if type == 'data/best.txt':
        individual = best_agent_skill()
        return individual

    creator.create("FitnessMax", base.Fitness, weights=(+1.0,))
    creator.create("Individual", list, fitness=creator.FitnessMax)

    toolbox = base.Toolbox()

    toolbox.register("chromosome", chromosome)
    toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.chromosome, n=1)
    toolbox.register("population", tools.initRepeat, list, toolbox.individual)

    toolbox.register("evaluate", evaluate3)
    toolbox.register("mate", tools.cxTwoPoint)
    toolbox.register("mutate", tools.mutFlipBit, indpb=0.05)
    toolbox.register("select", tools.selTournament, tournsize=3)

    best_solution = find_best_individual(toolbox)
    return best_solution[0]


def main_test():
    # creator.create("FitnessMin", base.Fitness, weights=(-1.0,))
    creator.create("FitnessMax", base.Fitness, weights=(+1.0,))
    creator.create("Individual", list, fitness=creator.FitnessMax)

    toolbox = base.Toolbox()

    toolbox.register("chromosome", chromosome)
    toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.chromosome, n=1)
    toolbox.register("population", tools.initRepeat, list, toolbox.individual)

    toolbox.register("evaluate", evaluate3)
    toolbox.register("mate", tools.cxTwoPoint)
    toolbox.register("mutate", tools.mutFlipBit, indpb=0.05)
    toolbox.register("select", tools.selTournament, tournsize=3)

    best_solution = find_best_individual(toolbox)
    print(best_solution[0])
    hist, bins = np.histogram(best_solution[0], bins=np.arange(np_agents_table.shape[0] + 1))
    print(hist)
    print(evaluate3(best_solution))
    return best_solution[0]


if __name__ == '__main__':
    # main_test()
    evaluate_repository()
