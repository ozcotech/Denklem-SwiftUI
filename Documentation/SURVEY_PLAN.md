# Survey (Mini Bilgi Testi) Feature Plan

## Amaç
Kullanıcıyla etkileşim kurmak, hukuki bilgi paylaşmak ve uygulama hakkında geri bildirim almak.

## Akış
1. StartScreen sağ üst köşede toolbar butonu (`list.bullet`)
2. Butona tıklayınca SurveyView'e navigation
3. Kart kart ilerleyen 2 soruluk mini bilgi testi
4. Her soru cevaplandıktan sonra doğru/yanlış feedback + açıklama
5. Tüm sorular bittikten sonra teşekkür mesajı
6. Anket tamamlandığında buton gizlenir (bir daha gösterilmez)

## Sorular

### Soru 1
**Soru:** Arabuluculuk süreci sonunda görev tarihindeki yıla göre mi yoksa son tutanağın imzalandığı ve/veya düzenlendiği tarihe göre mi makbuz düzenlenir?
- a) Görev Tarihi
- b) Son Tutanağın İmzalandığı ve/veya Düzenlendiği Tarih ✓

**Açıklama:** Son tutanağın imzalandığı ve/veya düzenlendiği tarihteki tarifeye göre makbuz düzenlenir.

### Soru 2
**Soru:** Arabuluculuk sürecine katılan taraf vekili anlaşma veya anlaşmama hallerinde avukatlık ücretine hak kazanır mı?
- a) Evet ✓
- b) Hayır

**Açıklama:** Evet, anlaşma veya anlaşmama hallerinde sürece vekaletnamesiyle katılan avukata tarifeye göre müvekkili tarafından ücret ödenmesi zorunludur.

## Teşekkür Mesajı
Mini bilgi testimize katıldığınız için teşekkür ederiz. Bu şekilde mini testleri çözmek isterseniz, bize yazmaktan çekinmeyin.
Ayrıca uygulamada takıldığınız, eksik bulduğunuz veya eklenmesini istediğiniz bir özellik varsa görüşlerinizi bizimle paylaşabilirsiniz.
Uygulamamızı beğendiyseniz tanıdıklarınıza önererek daha fazla kişiye ulaşmasına da katkıda bulunabilirsiniz.
Mail adresimiz: info@denklem.org

## Dosyalar
- `Views/Screens/Survey/SurveyView.swift`
- `Views/Screens/Survey/SurveyViewModel.swift`
- Modify: `StartScreenView.swift`, `StartScreenViewModel.swift`
- Modify: `LocalizationKeys.swift`, `Localizable.xcstrings`
