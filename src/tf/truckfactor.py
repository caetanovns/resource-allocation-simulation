import numpy as np

# np.random.seed(41)
# repository = np.random.randint(0, 99, (n_files, n_developers))


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


def getCoverage(n_files,authors_mapped):
    return np.sum(authors_mapped)/n_files


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
