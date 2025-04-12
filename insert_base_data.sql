-- Insertion des données dans la table jeu
INSERT INTO public.jeu
(id, nom, etape, nb_niveau, description, regles, message_fin, photo, temps_max)
VALUES(1, 'Carte vitale', 1, 1, 'Amélie retrouve sa carte Vitale en morceaux après la soirée d''intégration. Aide-la à la reconstituer au plus vite !', '', 'La carte Vitale contient les informations personnelles nécessaires au remboursement de tes frais de santé ou en cas d''hospitalisation. C''est la garantie d''être bien remboursé rapidement. En cas de perte, tu peux en commander une nouvelle directement depuis ton compte sur ameli.fr', '', 60);
INSERT INTO public.jeu
(id, nom, etape, nb_niveau, description, regles, message_fin, photo, temps_max)
VALUES(2, 'C2S', 2, 1, 'Seb est allé aux urgences parce qu''il s''est cassé le pied au foot. Il doit payer une partie des soins \(radio, plâtre…\) parce qu''il n''a pas de complémentaire santé ! Mets dans le panier tout ce qu''une complémentaire santé prend en charge !', '', 'La complémentaire santé solidaire \(C2S\) est une aide pour payer ses dépenses de santé, si tes ressources sont faibles. Avec la C2S tu ne paies pas le médecin, ni tes médicaments en pharmacie. La plupart des lunettes et des soins dentaires sont pris en charge. Tu peux faire une simulation sur ameli.fr pour savoir si tu y as droit !', '', 60);
INSERT INTO public.jeu
(id, nom, etape, nb_niveau, description, regles, message_fin, photo, temps_max)
VALUES(3, 'RIB', 3, 2, 'La mère de Pauline l''appelle pour lui dire qu''elle a eu des remboursements de consultations par l''Assurance Maladie qui ne la concernent pas… « T''as bien mis à jour ton RIB à la CPAM ? » Aide Pauline à compléter son RIB !', '', 'Les remboursements de l''Assurance Maladie se font par virement bancaire. Depuis ton compte ameli, enregistrer ton RIB c''est être sûr de recevoir les remboursements sur ton propre compte bancaire !', '', 60);
INSERT INTO public.jeu
(id, nom, etape, nb_niveau, description, regles, message_fin, photo, temps_max)
VALUES(4, 'Examen de prévention', 4, 1, 'Amélie adore manger des pizzas accompagnées d''un soda, même si elle sait que pas top pour sa santé… Coupe les aliments les moins bons pour sa santé !', '', 'L''Assurance Maladie offre aux jeunes de 16 à 25 ans un examen de prévention santé. Il peut être réalisé dans un centre d''examens de santé.', '', 60);
INSERT INTO public.jeu
(id, nom, etape, nb_niveau, description, regles, message_fin, photo, temps_max)
VALUES(5, 'M''T dents', 5, 1, 'Damien a mal aux dents… Brosse ses dents avec du dentifrice pour enlever les restes alimentaires et lui faire retrouver le sourire !', '', 'Pour garder le sourire : 1/ brosse-toi correctement les dents 2 fois par jour pendant 2 minutes 2/ consulte ton dentiste au moins une fois par an L''Assurance Maladie offre des rendez-vous de prévention avec le dentiste appelés « M''T dents » aux jeunes de âgés de 18, 21 et 24 ans !', '', 60);

-- Insertion des données dans la table parametres
INSERT INTO public.parametres (id, date_cloture, date_debut)
VALUES
    (1, '2025-10-30 00:00:00', '2025-04-08 00:00:00')
    ON CONFLICT (id) DO NOTHING;

-- Insertion des données dans la table token
INSERT INTO public.token (id, key, created_at)
VALUES
    (1, 'test', '2025-03-30 00:00:00')
    ON CONFLICT (id) DO NOTHING;
