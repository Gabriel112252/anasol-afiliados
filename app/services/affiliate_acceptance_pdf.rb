require "prawn"

class AffiliateAcceptancePdf
  BRAND = "ANASOL"
  BRAND_COLOR = "0A1F3D"
  DARK_COLOR = "0A1F3D"
  MUTED_COLOR = "6B7280"
  LIGHT_COLOR = "FFFBEF"
  BORDER_COLOR = "E7DDBD"

  def initialize(affiliate)
    @affiliate = affiliate
  end

  def render
    Prawn::Document.new(
      page_size: "A4",
      margin: [90, 52, 60, 52],
      info: {
        Title: "Comprovante de Aceite - Programa de Afiliados Anasol",
        Author: "Anasol"
      }
    ) do |pdf|
      draw_letterhead(pdf)
      draw_terms(pdf)
      pdf.start_new_page
      draw_acceptance(pdf)
      draw_page_numbers(pdf)
    end.render
  end

  private

  def draw_letterhead(pdf)
    pdf.repeat(:all) do
      logo_path = Rails.root.join("app/assets/images/title.png")

      if File.exist?(logo_path)
        pdf.image logo_path.to_s, at: [52, 815], width: 150
      else
        pdf.fill_color BRAND_COLOR
        pdf.fill_rounded_rectangle [52, 815], 150, 28, 14
        pdf.fill_color "FFFFFF"
        pdf.draw_text BRAND, at: [83, 805], size: 12, style: :bold
      end

      pdf.fill_color DARK_COLOR
      pdf.draw_text "PROGRAMA DE AFILIADOS", at: [398, 808], size: 7.5, style: :bold
      pdf.fill_color MUTED_COLOR
      pdf.draw_text "Regulamento e comprovante de aceite", at: [362, 796], size: 7

      pdf.stroke_color BORDER_COLOR
      pdf.line_width 0.6
      pdf.stroke_line [52, 782], [543, 782]
      pdf.stroke_line [52, 48], [543, 48]

      pdf.fill_color MUTED_COLOR
      pdf.draw_text "Anasol - Programa de Afiliados | Documento de registro eletrônico", at: [52, 35], size: 6.8
    end
  end

  def draw_page_numbers(pdf)
    pdf.number_pages "Página <page> de <total>",
      at: [463, 35],
      width: 80,
      align: :right,
      size: 6.8,
      color: MUTED_COLOR
  end

  def draw_terms(pdf)
    heading(pdf, "REGULAMENTO DO PROGRAMA DE AFILIADOS", 17)
    pdf.fill_color MUTED_COLOR
    pdf.text "Programa Afiliadas Elite Anasol", size: 7.8
    pdf.move_down 10

    section(pdf, "1. Objetivo")
    body(pdf, "O Programa de Afiliados TikTok Shop tem como objetivo escalar vendas, gerar prova social e consolidar presença da marca dentro do TikTok por meio de creators e afiliados, utilizando a estratégia de progressão por performance.")
    body(pdf, "O programa é dividido em níveis, com benefícios, responsabilidades e metas claras.")

    section(pdf, "2. Estrutura dos Níveis")
    body(pdf, "O programa é estruturado em níveis progressivos, pensados para incentivar performance, constância e crescimento de GMV.")
    subsection(pdf, "2.1 Afiliado Performance")
    body(pdf, "Ponto de entrada para qualquer creator ou afiliado que deseja começar a monetizar com a marca no TikTok Shop.")
    bullets(pdf, [
      "Validar sua capacidade de venda e criação de conteúdo",
      "Construir histórico de GMV e conversão",
      "Participar de campanhas abertas e desafios"
    ])
    subsection(pdf, "2.2 Afiliados Elite")
    body(pdf, "O nível Elite é o topo do programa - grupo seleto, limitado e altamente desejado.")
    bullets(pdf, [
      "Acesso a comissões mais altas",
      "Recebimento de press kit exclusivo",
      "Prioridade em campanhas, lançamentos e ativações",
      "Acesso a grupo fechado, treinamentos e suporte direto",
      "Reconhecimento público como creator parceiro da marca"
    ])

    section(pdf, "3. Critérios de Entrada")
    subsection(pdf, "3.1 Entrada como Afiliado")
    bullets(pdf, [
      "Conta ativa no TikTok",
      "Conformidade com as diretrizes da plataforma",
      "Conteúdo alinhado ao posicionamento da marca",
      "Aprovação via TikTok Shop"
    ])
    subsection(pdf, "3.2 Afiliado Elite")
    body(pdf, "A entrada no nível Elite pode ocorrer por convite direto ou progressão por performance.")
    bullets(pdf, [
      "Histórico de vendas comprovado no TikTok Shop",
      "Conteúdo recorrente e alinhado à marca",
      "Compromisso com entregas de conteúdo"
    ])

    section(pdf, "4. Comissões")
    subsection(pdf, "Afiliado Performance")
    bullets(pdf, ["Vendas orgânicas: 15%", "Vendas com ADS: 7%"])
    subsection(pdf, "Afiliado Elite")
    bullets(pdf, ["Vendas orgânicas: 20%", "Vendas com ADS: 8,5%"])

    section(pdf, "5. Regras de Amostra e Press Kit")
    subsection(pdf, "5.1 Afiliado Performance")
    body(pdf, "O Afiliado Performance não possui envio automático de amostras ou press kit. A marca poderá liberar envios pontuais apenas em campanhas específicas.")
    subsection(pdf, "5.2 Afiliado Elite")
    body(pdf, "O envio do press kit é um benefício condicionado à performance e entregas.")
    bullets(pdf, [
      "Conteúdo mínimo: 1 vídeo de unboxing + 3 vídeos de cada produto",
      "Prazo: publicação em até 7 dias corridos após recebimento",
      "Proibida revenda ou repasse dos produtos"
    ])

    section(pdf, "6. Metas e Progressão")
    body(pdf, "A progressão é baseada em mérito comprovado, consistência e impacto real no GMV da marca.")
    subsection(pdf, "Progressão para Elite")
    bullets(pdf, [
      "Crescimento contínuo de vendas",
      "Conteúdo recorrente e alinhado ao posicionamento da marca",
      "Baixa taxa de cancelamento",
      "Avaliação em janelas mensais consecutivas com validação interna"
    ])

    section(pdf, "7. Penalidades, Rebaixamento e Exclusão")
    subsection(pdf, "7.1 Penalidades Leves")
    body(pdf, "Atraso na entrega, uso incorreto de links, descumprimento leve de diretrizes.")
    bullets(pdf, ["Advertência, solicitação de correção, perda temporária de benefícios"])
    subsection(pdf, "7.2 Penalidades Graves")
    body(pdf, "Não publicação de conteúdos obrigatórios, promessas médicas, revenda de produtos.")
    bullets(pdf, ["Rebaixamento imediato, redução/bloqueio de comissões, suspensão de envios"])
    subsection(pdf, "7.3 Fraudes e Má-fé")
    body(pdf, "Compras falsas, manipulação de GMV, uso de bots: exclusão imediata e definitiva do programa.")

    section(pdf, "8. Regras de Conteúdo e Comunicação")
    subsection(pdf, "É expressamente proibido:")
    bullets(pdf, [
      "Prometer cura, tratamento médico ou resultados garantidos",
      "Utilizar linguagem clínica ou médica",
      "Fazer comparações depreciativas com concorrentes",
      "Divulgar informações internas ou confidenciais do programa"
    ])
    subsection(pdf, "É obrigatório:")
    bullets(pdf, [
      "Linguagem realista, experiencial e transparente",
      "Uso correto dos produtos",
      "Cumprimento das políticas do TikTok Shop"
    ])

    section(pdf, "9. Direitos e Reservas da Marca")
    bullets(pdf, [
      "Alterar este regulamento a qualquer momento",
      "Ajustar comissões, metas e critérios",
      "Encerrar parcerias sem aviso prévio em caso de descumprimento",
      "Utilizar conteúdos produzidos pelos afiliados para fins institucionais e promocionais"
    ])
    body(pdf, "Nenhum nível, benefício ou comissão é considerado direito adquirido.")
    subsection(pdf, "9.1 Alterações de Preços, Comissões e Condições Comerciais")
    body(pdf, "A Anasol poderá, a qualquer momento e de acordo com sua estratégia comercial, condições de mercado, campanhas, políticas da plataforma TikTok Shop, custos operacionais, posicionamento de produtos ou demais fatores comerciais, alterar os preços dos produtos, percentuais de comissão, condições de campanhas, incentivos, benefícios, critérios de participação e demais condições comerciais disponibilizadas aos afiliados dentro da plataforma TikTok Shop, sem que tais alterações caracterizem descumprimento das condições anteriormente praticadas ou gerem direito adquirido à manutenção dos valores ou percentuais anteriores.")
    body(pdf, "As alterações realizadas na plataforma TikTok Shop serão aplicáveis conforme as condições e vigência estabelecidas pela própria plataforma e/ou pela Anasol, observadas as regras e políticas vigentes do TikTok Shop.")
    body(pdf, "A afiliada declara estar ciente de que preços de produtos, percentuais de comissão, campanhas promocionais, incentivos e demais condições comerciais podem sofrer alterações ao longo da parceria, não havendo garantia de manutenção dos mesmos valores, percentuais ou benefícios durante todo o período de participação no Programa de Afiliados.")
    body(pdf, "Eventuais comissões referentes às vendas serão calculadas de acordo com o percentual e as condições vigentes e efetivamente disponibilizados na plataforma TikTok Shop no momento aplicável à venda, observadas as regras da própria plataforma.")

    section(pdf, "10. Confidencialidade")
    body(pdf, "Informações estratégicas, critérios internos e benefícios exclusivos são confidenciais. É proibida a divulgação de condições comerciais especiais e estratégias internas.")

    section(pdf, "11. Termo de Uso de Imagem")
    body(pdf, "Ao se cadastrar no Programa de Afiliados Anasol, a afiliada autoriza, de forma expressa, gratuita e sem limitação territorial, a utilização da sua imagem, voz, vídeos, fotos e demais conteúdos audiovisuais produzidos no contexto da parceria com a marca Anasol.")
    body(pdf, "Esta autorização abrange a divulgação, reprodução, edição e veiculação dos conteúdos em qualquer mídia ou plataforma digital - incluindo TikTok, Instagram, YouTube e outros canais institucionais da marca - para fins de publicidade e promoção dos produtos Anasol.")
    body(pdf, "A participação no programa implica na aceitação integral deste Termo de Uso de Imagem, que permanece vigente durante toda a parceria e, no que se refere a conteúdos já publicados, após o eventual encerramento da mesma.")

    section(pdf, "12. Aceite")
    body(pdf, "A participação no Programa de Afiliados implica na aceitação integral, irrestrita e automática deste regulamento.")
  end

  def draw_acceptance(pdf)
    pdf.move_down 22
    heading(pdf, "COMPROVANTE DE ACEITE", 19, align: :center)
    pdf.fill_color MUTED_COLOR
    pdf.text "Registro eletrônico vinculado ao cadastro da afiliada", align: :center, size: 9
    pdf.move_down 18

    pdf.fill_color LIGHT_COLOR
    pdf.stroke_color BRAND_COLOR
    pdf.line_width 1
    box_top = pdf.cursor
    pdf.fill_rectangle [0, box_top], pdf.bounds.width, 66
    pdf.stroke_rectangle [0, box_top], pdf.bounds.width, 66
    pdf.fill_color DARK_COLOR
    pdf.text_box "ACEITE REGISTRADO", at: [12, box_top - 12], width: pdf.bounds.width - 24, height: 16, size: 10, style: :bold
    pdf.fill_color "374151"
    pdf.text_box "A afiliada abaixo identificada declarou que leu e aceitou integralmente o Regulamento do Programa de Afiliados e o Termo de Uso de Imagem apresentados nas páginas anteriores.", at: [12, box_top - 30], width: pdf.bounds.width - 24, height: 31, size: 9, leading: 3
    pdf.move_down 82

    acceptance_rows.each do |label, value, height|
      acceptance_field(pdf, label, value, height: height)
    end

    pdf.move_down 18
    subsection(pdf, "Declaração de registro")
    body(pdf, "Este documento foi emitido a partir dos dados armazenados no sistema do Programa de Afiliados Anasol. A data e a hora acima correspondem ao registro eletrônico do aceite realizado no cadastro.")
    pdf.move_down 8
    body(pdf, "Identificação do documento: #{document_id}", size: 8, color: MUTED_COLOR)
    pdf.move_down 14
    body(pdf, "Documento gerado automaticamente. Não requer assinatura manuscrita para comprovar o registro eletrônico do aceite no sistema.", size: 7.5, color: MUTED_COLOR)
  end

  def acceptance_rows
    [
      ["Nome completo", @affiliate.full_name, 29],
      ["CPF", @affiliate.cpf, 29],
      ["E-mail", @affiliate.email, 29],
      ["WhatsApp", @affiliate.whatsapp, 29],
      ["TikTok", @affiliate.tiktok, 29],
      ["Endereço", full_address, 38],
      ["Cidade / Estado", [@affiliate.city, @affiliate.state].compact.join(" / "), 29],
      ["CEP", @affiliate.zip_code, 29],
      ["Data e hora do aceite", accepted_at_text, 34],
      ["Status do aceite", @affiliate.terms_accepted? ? "SIM - aceite registrado eletronicamente" : "NÃO", 29]
    ]
  end

  def acceptance_field(pdf, label, value, height: 29)
    y = pdf.cursor
    pdf.fill_color "FFFDF7"
    pdf.fill_rectangle [0, y], 140, height
    pdf.stroke_color BORDER_COLOR
    pdf.line_width 0.5
    pdf.stroke_rectangle [0, y], pdf.bounds.width, height

    pdf.fill_color MUTED_COLOR
    pdf.text_box label.to_s, at: [8, y - 9], width: 124, height: height - 8, size: 8, style: :bold, valign: :center
    pdf.fill_color DARK_COLOR
    pdf.text_box value.presence || "-", at: [148, y - 8], width: pdf.bounds.width - 156, height: height - 8, size: 9, style: :bold, valign: :center
    pdf.move_down height
  end

  def full_address
    first_line = [@affiliate.street, @affiliate.number].compact_blank.join(", ")
    first_line += " - #{@affiliate.complement}" if @affiliate.complement.present?
    [first_line, @affiliate.neighborhood].compact_blank.join(" - ")
  end

  def accepted_at
    @accepted_at ||= @affiliate.terms_accepted_at || (@affiliate.terms_accepted? ? @affiliate.created_at : nil)
  end

  def accepted_at_text
    return "Não registrado" unless accepted_at

    accepted_at.in_time_zone("America/Sao_Paulo").strftime("%d/%m/%Y às %H:%M (America/Sao_Paulo)")
  end

  def document_id
    timestamp = accepted_at&.to_i || @affiliate.created_at.to_i
    "ANA-ACEITE-#{@affiliate.id}-#{timestamp}"
  end

  def heading(pdf, text, size, align: :left)
    pdf.fill_color BRAND_COLOR
    pdf.text text, size: size, style: :bold, align: align, leading: 3
    pdf.move_down 5
  end

  def section(pdf, text)
    pdf.move_down 7
    heading(pdf, text, 11)
  end

  def subsection(pdf, text)
    pdf.fill_color DARK_COLOR
    pdf.text text, size: 9.5, style: :bold, leading: 2
    pdf.move_down 3
  end

  def body(pdf, text, size: 9, color: "374151")
    pdf.fill_color color
    pdf.text text, size: size, leading: 3
    pdf.move_down 5
  end

  def bullets(pdf, items)
    items.each do |item|
      pdf.fill_color "374151"
      pdf.text "• #{item}", size: 9, leading: 3, indent_paragraphs: 10
      pdf.move_down 2
    end
  end
end
