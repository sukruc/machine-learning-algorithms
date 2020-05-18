import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


class OrtamHatasi(Exception):
    pass


class Ortam:
    def __init__(self, filename=None):
        self.n = 0
        self.n_ads = None
        self.max_n = None
        self.data = None
        self.veri_oku(filename)

    def yenile(self):
        self.n = 0

    def veri_oku(self, filename):
        self.data = pd.read_csv(filename)
        self.max_n = self.data.shape[0]
        self.data.columns = list(range(len(self.data.columns)))
        self.n_ads = self.data.shape[1]

    def goruntule(self, ad_num):
        if self.n >= self.max_n:
            raise OrtamHatasi('Bu Ortam nesnesi tukendi.')
        odul = self.data.loc[self.n, ad_num]
        self.n += 1
        return odul


class SentetikOrtam:
    def __init__(self, probas):
        self.n = 0
        self.n_ads = len(probas)
        self.probas = probas

    def goruntule(self, ad_num):
        p = self.probas[ad_num]
        odul = np.random.choice([0, 1], p=[1-p, p])
        self.n += 1
        return odul

    def yenile(self):
        pass


class GecikmeliOrtam(Ortam):
    def __init__(self, *args, geri_besleme_olasiligi=0.2, **kwargs):
        Ortam.__init__(self, *args, **kwargs)
        self.tutulan_tablo = {}
        self.geri_besleme_olasiligi = geri_besleme_olasiligi

    def tutulani_bosalt(self):
        self.tutulan_tablo = {}

    def goruntule(self, ad_num):
        if self.n >= self.max_n:
            raise OrtamHatasi('Bu Ortam nesnesi tukendi.')
        odul = self.data.loc[self.n, ad_num]
        self.n += 1
        if ad_num not in self.tutulan_tablo:
            self.tutulan_tablo[ad_num] = {'Ni': 0, 'Ri': 0}
        self.tutulan_tablo[ad_num]['Ni'] += 1
        self.tutulan_tablo[ad_num]['Ri'] += odul
        if np.random.random() < self.geri_besleme_olasiligi:
            sonuc = self.tutulan_tablo
            self.tutulani_bosalt()
        else:
            sonuc = {}
        return sonuc


class Ajan:
    def __init__(self, n_ads):
        self.n_ads = n_ads
        self.n = 0
        self.tablo = {reklam_no: {'Ni': 0, 'Ri': 0}
                      for reklam_no in range(self.n_ads)}

    def sayaci_artir(self):
        self.n += 1

    def reklam_sec(self):
        pass

    def tabloya_kat(self, reklam_no, cikti):
        self.tablo[reklam_no]['Ni'] += 1
        self.tablo[reklam_no]['Ri'] += cikti

    def tabloyu_guncelle(self):
        pass

    def ogren(self, ortam):
        try:
            reklam_no = self.reklam_sec()
            cikti = ortam.goruntule(reklam_no)
            self.tabloya_kat(reklam_no, cikti)
            self.tabloyu_guncelle()
        except OrtamHatasi:
            pass

    def toplam_odul(self):
        return sum([reklam['Ri'] for reklam in self.tablo.values()])

    def tablo_goruntule(self):
        return pd.DataFrame(self.tablo).round(2)


class GecikmeliAjan(Ajan):
    def tabloya_kat(self, reklam_sozlugu):
        # {3: {'Ni':5, 'Ri':1},
        #  5: {'Ni':17, 'Ri':12}}
        for reklam in reklam_sozlugu:
            self.tablo[reklam]['Ni'] += reklam_sozlugu[reklam]['Ni']
            self.tablo[reklam]['Ri'] += reklam_sozlugu[reklam]['Ri']

    def ogren(self, ortam):
        try:
            reklam_no = self.reklam_sec()
            cikti = ortam.goruntule(reklam_no)
            self.tabloya_kat(cikti)
            self.tabloyu_guncelle()
        except OrtamHatasi:
            pass


class RassalAjan(Ajan):
    def reklam_sec(self):
        self.sayaci_artir()
        return np.random.randint(self.n_ads)


class UCBAjan(Ajan):
    def tabloyu_guncelle(self):
        for reklam in self.tablo.values():
            reklam['ri'] = reklam['Ri'] / (reklam['Ni'] + 1e-17)
            delta = (1.5 * np.log(self.n) / (reklam['Ni'] + 1e-17))
            reklam['UCB'] = reklam['ri'] + delta
            reklam['LCB'] = reklam['ri'] - delta

    def reklam_sec(self):
        reklam = max(self.tablo.items(),
                     key=lambda x: x[1].get('UCB', 1e9))[0]
        self.sayaci_artir()
        return reklam


class GecikmeliUCB(GecikmeliAjan, UCBAjan):
    pass


class ThompsonAjan(Ajan):
    def tabloyu_guncelle(self):
        for reklam in self.tablo.values():
            reklam['Ni1'] = reklam['Ri']
            reklam['Ni0'] = reklam['Ni'] - reklam['Ri']
            reklam['beta'] = np.random.beta(reklam['Ni1'] + 1,
                                            reklam['Ni0'] + 1)

    def reklam_sec(self):
        reklam = max(self.tablo.items(),
                     key=lambda x: x[1].get('beta', 1e9))[0]
        self.sayaci_artir()
        return reklam


class GecikmeliThompson(GecikmeliAjan, ThompsonAjan):
    pass


if __name__ == '__main__':
    ort = Ortam('Ads_CTR_Optimisation.csv')  # kac reklam var? kolonlari numaraye cevir
    # ajan = UCBAjan()
    ad = 8
    print('Secilen reklam:', ad)
    print('Sonuc:', ort.goruntule(ad))
    # print('Sonuc:', ort.goruntule(ajan.reklam_sec()))
