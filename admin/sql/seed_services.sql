-- ============================================================
-- Hizmet Kartları Başlangıç Verisi (service_items) — schema.sql SONRASI çalıştırın
-- ============================================================

INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'bolt',N'Elektrik Tesisatı',N'Konut, işyeri ve sanayi tesislerinde iç tesisat kurulumu ve yenileme.',0);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Pano İmalatı & Montajı',N'İhtiyaca uygun dağıtım ve kumanda panolarının imalatı ve devreye alınması.',1);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Aydınlatma Sistemleri',N'İç ve dış mekân aydınlatma projelendirmesi ve LED dönüşüm çözümleri.',2);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Topraklama & Paratoner',N'Topraklama ölçümleri, paratoner tesisi ve yıldırımdan korunma sistemleri.',3);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Bakım-Onarım',N'Periyodik bakım ve arıza müdahalesiyle kesintisiz elektrik hizmeti.',4);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Elektrik Projelendirme',N'Mevzuata uygun elektrik projesi çizimi ve resmi onay süreçleri.',5);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Alçak ve Orta Gerilim Elektrik Projeleri',N'AG/OG elektrik tesisatının projelendirilmesi ve uygulanması.',6);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Trafo ve Enerji Nakil Hattı Yapımı',N'Trafo merkezi kurulumu ve enerji nakil hattı (ENH) inşası.',7);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Kompanzasyon Pano İmalatı ve Revizyonu',N'Reaktif enerji cezalarını önleyen kompanzasyon panolarının imalatı ve yenilenmesi.',8);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'elektrik',N'check',N'Kompanzasyon Takibi',N'Kompanzasyon sistemlerinin düzenli ölçüm ve performans takibi.',9);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'enerji',N'pulse',N'Enerji Verimliliği Danışmanlığı',N'Tesislerde enerji tüketimini azaltacak analiz ve iyileştirme önerileri.',0);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'enerji',N'battery',N'Kompanzasyon Sistemleri',N'Reaktif enerji cezalarını önleyecek kompanzasyon panosu kurulumu.',1);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'enerji',N'check',N'Güneş Enerjisi Sistemleri (GES)',N'Çatı ve arazi tipi güneş enerjisi sistemleri için proje ve kurulum danışmanlığı.',2);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'enerji',N'check',N'Enerji Kimlik Belgesi',N'Bina enerji performansının mevzuata uygun şekilde belgelendirilmesi.',3);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'enerji',N'check',N'Orta/Yüksek Gerilim İşleri',N'Trafo, hücre ve orta gerilim tesislerinde bakım ve işletme desteği.',4);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'enerji',N'check',N'Enerji İzleme & Raporlama',N'Tüketim verilerinin izlenmesi ve düzenli performans raporlaması.',5);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'asansor',N'check',N'Asansör Montajı',N'Yeni bina ve mevcut yapılarda anahtar teslim asansör montajı.',0);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'asansor',N'check',N'Periyodik Bakım',N'Yönetmeliklere uygun aylık periyodik bakım ve kontrol hizmeti.',1);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'asansor',N'check',N'Revizyon',N'Eski asansörlerin güncel güvenlik standartlarına uygun hale getirilmesi.',2);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'yazilim',N'check',N'Özel Yazılım Geliştirme',N'İşletmenizin ihtiyacına özel masaüstü yazılım geliştirme.',0);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'yazilim',N'check',N'İşletme Otomasyonu',N'Günlük operasyonu tek ekrandan yönetecek otomasyon çözümleri.',1);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'yazilim',N'check',N'POS & Kasa Takibi',N'Ödeme ve kasa hareketlerinin güvenle takip edildiği yazılımlar.',2);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'yazilim',N'check',N'Muhasebe Yazılımları',N'Gelir-gider ve cari hesap takibini kolaylaştıran muhasebe araçları.',3);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'yazilim',N'check',N'Bakım & Güncelleme Desteği',N'Kurulan yazılımlar için sürekli bakım ve güncelleme desteği.',4);
INSERT INTO service_items (category,icon_key,title,description,sort_order) VALUES (N'yazilim',N'check',N'Kullanıcı Eğitimi',N'Ekibinizin yazılımı verimli kullanabilmesi için yerinde eğitim.',5);