import pandas as pd
import numpy as np


class UCB:
    def __init__(self, n_choices):
        self.n_choices = n_choices
        self.n_round = 0
        self.ad_data = {ad:
                        {
                             "Ni": 0, "Ri": 0, "UCB": 1e5
                        } for ad in range(n_choices)
                        }

    def select_ad(self):
        return max(self.ad_data.items(), key=lambda x: x[1]["UCB"])[0]

    def update_ad(self, ad, reward):
        self.n_round += 1
        self.ad_data[ad]['Ni'] += 1
        self.ad_data[ad]['Ri'] += reward
        self.ad_data[ad]['UCB'] = self.calculate_ucb(self.ad_data[ad]['Ni'],
                                                     self.ad_data[ad]['Ri'],
                                                     self.n_round)

    @staticmethod
    def calculate_ucb(Ni, Ri, n):
        r_bar = Ri / Ni  # average reward
        delta_i = np.sqrt(3 / 2 * np.log(n) / Ni)
        ucb = r_bar + delta_i  # upper confidence bound
        return ucb

    def ohe(self, ad_num):
        return ad_num == np.arange(self.n_choices)


if __name__ == '__main__':
    model = UCB(n_choices=10)
    rewards = pd.read_csv('Ads_CTR_Optimisation.csv')
    rewards_resampled = rewards.sample(rewards.shape[0]).values

    for i in range(rewards_resampled.shape[0]):
        ad = model.select_ad()
        reward = ((rewards_resampled[i, :] == 1) & (model.ohe(ad))).sum()

        model.update_ad(ad, reward)
    result = (pd.DataFrame(model.ad_data).T)
    print(result)
    print("Total reward:", result['Ri'].sum())
