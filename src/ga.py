import numpy as np
import random
import time
from deap import base
from deap import creator
from deap import tools
from numpy.random import seed
from numpy.random import randint
import time
import logging
import copy

# np_task_table = np.array([])
# np_agents_table = np.array([])
# np_repository = np.array([])
# np_task_file_table
# np_task_commit_table

# np.random.seed(32)

# np_agents_table = np.random.rand(5, 6)
# np_task_table = np.random.randint(10, 3)
# np_repository = np.array([])

# 0 - Weight's Task
# 1 - Knowledge list
# 2 - File
# np_agents_table = np.array([[1, 2, 60], [4, 5, 6], [7, 8, 9], [10, 11, 12], [1, 2, 60]])
# np_task_table = np.array([[1, 0, 1], [1, 1, 1], [1, 0, 1], [1, 1, 1]])
# np_repository = np.array([[1, 0, 0], [0, 1, 0]])


# np_agents_table = np.array([[10, 11], [11, 12]])
# np_task_table = np.array([[10, 0, 999], [10, 1, 999]])


# np_agents_table = np.array([[4, 2, 1], [1, 1, 1], [1, 0, 1]])
# np_task_table = np.array([[1, 2, 4], [0, 1, 0]])

# np_agents_table = np.array([[10, 0, 0, 1], [10, 5, 5, 6], [0, 10, 5, 4]])
# np_task_table = np.array([[1, 2, 4], [0, 1, 0]])

def analyzing_repository_doa(repository):
    np_rep = np.array(repository)
    doa = np.zeros(dtype=int, shape=(np_rep.shape[0], np_rep.shape[1]))

    index = 0
    for i in np_rep:
        doa[index, np.argmax(i, axis=0)] = 1
        index += 1
    # time.sleep(1)
    # print(doa)
    # time.sleep(1)
    return "OK"


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


# Função de aptidão totalmente em cima da variável do truck factor e a distribuição das pessoas.
def evaluate3(individual):
    tmp_repository = copy.copy(np_repository)

    individual = individual[0]
    for i in range(len(individual)):
        agent = individual[i]
        files = list (np_task_file_table[i])
        for j in range(len(files)):
            if files[j] != -1:
                tmp_repository[files[j]][agent] = tmp_repository[files[j]][agent] + np_task_change_table[i][j]

    truck_factor = start_tf(tmp_repository)

    #hist, bins = np.histogram(individual, bins=np.arange(np_agents_table.shape[1] + 1))
    #note_2 = np.var(hist)
    # print(truck_factor - note_2)
    return [truck_factor]


# Função de aptião é calculada avaliando a variância do repositório, onde a menor variância é mais interessante.
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

# Adaptação da simulação da evaluate4
def evaluate5(individual):
    tmp_repository = copy.copy(np_repository)

    #logging.warn(f'Repository - {tmp_repository}')
    individual = individual[0]
    for i in range(len(individual)):
        agent = individual[i]
        files = list (np_task_file_table[i])
        for j in range(len(files)):
            if files[j] != -1:
                tmp_repository[files[j]][agent] = tmp_repository[files[j]][agent] + np_task_change_table[i][j]

    variance_total = 0

    for i in tmp_repository:
        variance_total += np.var(i)
    
    #logging.warn(f'Repository - {tmp_repository}')

    # logging.warn(f'Variance - {variance_total} - Ind - {individual}')

    return [variance_total]

# com base no TF diteramente com o novo repositório
def evaluate6(individual):
    individual = individual[0]
    for i in range(len(individual)):
        agent = individual[i]
        # skills_required = list(np_task_table[i])
        # task_level_required = skills_required[0]
        # task_file = skills_required[2]
        files = list (np_task_file_table[i])
        # print(files)
        # print(np_task_change_table)
        for j in range(len(files)):
            if files[j] != -1:
                np_repository[files[j]][agent] = np_repository[files[j]][agent] + np_task_change_table[i][j]

    truck_factor = start_tf(np_repository)

    #hist, bins = np.histogram(individual, bins=np.arange(np_agents_table.shape[1] + 1))
    #note_2 = np.var(hist)
    # print(truck_factor - note_2)
    variance_total = 0

    for i in np_repository:
        variance_total += np.var(i)
    
    return [truck_factor - variance_total]

def find_best_individual(toolbox):
    pop = toolbox.population(n=100)

    # Evaluate the entire population
    fitnesses = list(map(toolbox.evaluate, pop))
    for ind, fit in zip(pop, fitnesses):
        ind.fitness.values = fit

    # CXPB  is the probability with which two individuals
    #       are crossed
    #
    # MUTPB is the probability for mutating an individual
    CXPB, MUTPB = 0.2, 0.2

    # Extracting all the fitnesses of
    fits = [ind.fitness.values[0] for ind in pop]

    # Variable keeping track of the number of generations
    g = 0

    #logging.warn(f'---------- Starting Generations --------')

    # Begin the evolution
    while g < 50 :
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
        

        #logging.warn(f'---------- Starting Invalid --------')
        # Evaluate the individuals with an invalid fitness
        invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
        fitnesses = map(toolbox.evaluate, invalid_ind)
        for ind, fit in zip(invalid_ind, fitnesses):
           ind.fitness.values = fit
        #logging.warn(f'---------- Ending Invalid --------')

        pop[:] = offspring

        # Gather all the fitnesses in one list and print the stats
        fits = [ind.fitness.values[0] for ind in pop]

        length = len(pop)
        mean = sum(fits) / length
        sum2 = sum(x * x for x in fits)
        std = abs(sum2 / length - mean ** 2) ** 0.5
        #logging.warn(f'---------- Searching Best --------')
        best_g = pop[np.argmax([toolbox.evaluate(x) for x in pop])]
        #logging.warn(f'---------- Found Best --------')
        logging.warn(f'Best of Generation nª{ g } - {evaluate3(best_g)}')

    logging.warn(f'---------- GLOBAL Best --------')
    best = pop[np.argmax([toolbox.evaluate(x) for x in pop])]
    logging.warn(f'Final Best {evaluate3(best)}')

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


def random_agent():
    values = randint(0, np_agents_table.shape[0], np_task_table.shape[0])
    logging.warn(f'Best of Generation {evaluate5([values])}')
    return values


def worse_agent_skill():
    individual = []
    for i in range(len(np_task_table)):
        task = list(np_task_table[i])
        task_level_required = task[0]
        knowledge_skill = task[1]
        best_agent_index = np_agents_table[:, knowledge_skill].argmin()
        np_agents_table[best_agent_index, knowledge_skill] += task_level_required
        individual.append(best_agent_index)

    return individual


def mean_agent_skill():
    task_agent_number = round(np_task_table.shape[0] / np_agents_table.shape[0])
    if task_agent_number == 0:
        task_agent_number = 1
    agents_tmp = []
    values = []

    mean_agents = []
    for i in range(len(np_agents_table)):
        mean_agents.append(round(np_agents_table[i, :].mean()))

    for i in range(np_agents_table.shape[0]):
        for j in range(task_agent_number):
            agents_tmp.append(np.sort(mean_agents)[-1])
        mean_agents.remove(np.sort(mean_agents)[-1])

    return agents_tmp


def evaluate_repository(repository, approach):
    # time.sleep(5)
    total = []
    for i in np.array(repository):
        total.append(round(np.var(i), 2))
        # print("APPROACH: {} AVG: {} VAR: {} MAX: {} MIN: {}".format(approach, round(np.average(i), 2),
                                                                    #round(np.var(i), 2), np.max(i),
                                                                    #np.min(i)))
    # print("RESUMO: VAR: {} MEAN: {}".format(round(np.var(total), 2), round(np.mean(total), 2)))
    return round(np.mean(total), 2)


def main(repository, a_table, t_table, type, file_table, change_table):
    global np_agents_table
    global np_task_table
    global np_task_file_table
    global np_task_change_table
    global np_repository

    np_agents_table = np.array(a_table)
    np_task_table = np.array(t_table)
    np_task_file_table = np.array(file_table)
    np_task_change_table = np.array(change_table)
    np_repository = np.array(repository)

    logging.basicConfig(filename='app.log', filemode='w', format='%(name)s - %(levelname)s - %(message)s')
    
    if type == 'data/random.txt':
        # np.random.seed(32)
        return random_agent()

    if type == 'data/best.txt':
        individual = best_agent_skill()
        return individual

    if type == 'data/worse.txt':
        individual = worse_agent_skill()
        return individual

    if type == 'data/mean.txt':
        individual = mean_agent_skill()
        return individual

    creator.create("FitnessMin", base.Fitness, weights=(1.0,))
    creator.create("Individual", list, fitness=creator.FitnessMin)

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
