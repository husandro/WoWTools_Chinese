


--邮箱 MailFrame.lua
--MailFrame:HookScript('OnShow', function(self)
InboxTooMuchMailText:SetText('你的收件箱已满。')
MailFrameTrialError:SetText('你需要升级你的账号才能开启这项功能。')
hooksecurefunc('MailFrameTab_OnClick', function(self, tabID)
    tabID = tabID or self:GetID()
    if tabID == 1  then
        MailFrame:SetTitle('收件箱')
    elseif tabID==2 then
        MailFrame:SetTitle('发件箱')
    end
end)
MailFrameTab1:SetText('收件箱')
    OpenAllMail:SetText('全部打开')
    hooksecurefunc(OpenAllMail,'StartOpening', function(self)
        self:SetText('正在打开……')
    end)
    hooksecurefunc(OpenAllMail,'StopOpening', function(self)
        self:SetText('全部打开')
    end)
    hooksecurefunc('InboxFrame_Update', function()
        local numItems = GetInboxNumItems()
        local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1
        for i=1, INBOXITEMS_TO_DISPLAY do
            if ( index <= numItems ) then
                local daysLeft = select(7, GetInboxHeaderInfo(index))
                if ( daysLeft >= 1 ) then
                    daysLeft = GREEN_FONT_COLOR_CODE..format('%d|4天:天', floor(daysLeft)).." "..FONT_COLOR_CODE_CLOSE
                else
                    daysLeft = RED_FONT_COLOR_CODE..SecondsToTime(floor(daysLeft * 24 * 60 * 60))..FONT_COLOR_CODE_CLOSE
                end
                local expireTime= _G["MailItem"..i.."ExpireTime"]
                if expireTime then
                    WoWTools_ChineseMixin:SetLabel(expireTime, daysLeft)
                    if ( InboxItemCanDelete(index) ) then
                        expireTime.tooltip = '信息保留时间'
                    else
                        expireTime.tooltip = '信息退回时间'
                    end
                end
            end
            index = index + 1
        end
    end)
    local region= InboxPrevPageButton:GetRegions()
    if region and region:GetObjectType()=='FontString' then
        region:SetText('上一页')
    end
    region= InboxNextPageButton:GetRegions()
    if region and region:GetObjectType()=='FontString' then
        region:SetText('下一页')
    end
    --[[region= select(3, SendMailNameEditBox:GetRegions())
    if region and region:GetObjectType()=='FontString' then
        region:SetText('收件人：')
    end]]
    region= select(3, SendMailSubjectEditBox:GetRegions())
    if region and region:GetObjectType()=='FontString' then
        region:SetText('主题：')
    end



MailFrameTab2:SetText('发件箱')
    SendMailMailButton:SetText('发送')
    SendMailCancelButton:SetText('取消')
    hooksecurefunc('SendMailRadioButton_OnClick', function(index)--MailFrame.lua
        if ( index == 1 ) then
            SendMailMoneyText:SetText('|cnRED_FONT_COLOR:寄送金额：')
        else
            SendMailMoneyText:SetText('|cnGREEN_FONT_COLOR:付款取信邮件的金额')
        end
    end)
    SendMailSendMoneyButtonText:SetText('|cnRED_FONT_COLOR:发送钱币')
    SendMailCODButtonText:SetText('|cnGREEN_FONT_COLOR:付款取信')
    hooksecurefunc('SendMailAttachment_OnEnter', function(self)
        local index = self:GetID()
        if ( not HasSendMailItem(index) ) then
            GameTooltip:SetText('将物品放在这里随邮件发送', 1.0, 1.0, 1.0)
        end
    end)


    OpenMailSenderLabel:SetText('来自：')
    OpenMailSubjectLabel:SetText('主题：')
    hooksecurefunc('OpenMail_Update', function()
        if not InboxFrame.openMailID then
            return
        end
        local _, _, _, _, isInvoice, isConsortium = GetInboxText(InboxFrame.openMailID)
        if ( isInvoice ) then
            local invoiceType, itemName, playerName, _, _, _, _, _, etaHour, etaMin, count, commerceAuction = GetInboxInvoiceInfo(InboxFrame.openMailID)
            if ( invoiceType ) then
                if ( playerName == nil ) then
                    playerName = (invoiceType == "buyer") and '多个卖家' or '多个买家'
                end
                local multipleSale = count and count > 1
                if ( multipleSale ) then
                    itemName = format(AUCTION_MAIL_ITEM_STACK, itemName, count)
                end
                OpenMailInvoicePurchaser:SetShown(not commerceAuction)
                if ( invoiceType == "buyer" ) then
                    OpenMailInvoicePurchaser:SetText("销售者： "..playerName)
                    OpenMailInvoiceAmountReceived:SetText('|cnRED_FONT_COLOR:付费金额：')
                elseif (invoiceType == "seller") then
                    OpenMailInvoiceItemLabel:SetText("物品售出： "..itemName)
                    OpenMailInvoicePurchaser:SetText("购买者： "..playerName)
                    OpenMailInvoiceAmountReceived:SetText('|cnGREEN_FONT_COLOR:收款金额：')

                elseif (invoiceType == "seller_temp_invoice") then
                    OpenMailInvoiceItemLabel:SetText("物品售出： "..itemName)
                    OpenMailInvoicePurchaser:SetText("购买者： "..playerName)
                    OpenMailInvoiceAmountReceived:SetText('等待发送的数量：')
                    OpenMailInvoiceMoneyDelay:SetFormattedText('预计投递时间%s', GameTime_GetFormattedTime(etaHour, etaMin, true))
                end
            end
        end

        if ( isConsortium ) then
            local info = C_Mail.GetCraftingOrderMailInfo(InboxFrame.openMailID) or {}
            if ( info.reason == Enum.RcoCloseReason.RcoCloseCancel ) then
                ConsortiumMailFrame.OpeningText:SetText('你的制造订单已被取消。')
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseExpire ) then
                ConsortiumMailFrame.OpeningText:SetText('你的制造订单已过期。')
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseFulfill ) then
                ConsortiumMailFrame.OpeningText:SetFormattedText('订单：%s',info.recipeName)
                ConsortiumMailFrame.CrafterText:SetFormattedText('完成者：|cnHIGHLIGHT_FONT_COLOR:%s|r', info.crafterName or "")
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseReject ) then
                ConsortiumMailFrame.OpeningText:SetFormattedText('订单：%s', info.recipeName)
                ConsortiumMailFrame.CrafterText:SetFormattedText('|cnHIGHLIGHT_FONT_COLOR:%s|r决定不完成此订单。', info.crafterName or "")
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseCrafterFulfill ) then
                ConsortiumMailFrame.OpeningText:SetFormattedText('订单：%s', info.recipeName)
                ConsortiumMailFrame.CrafterText:SetFormattedText('收件人：%s', info.customerName or "")
                ConsortiumMailFrame.ConsortiumNote:SetFormattedText('嗨，%1$s，你完成了%3$s的%2$s的订单，但还没寄给对方。因为你的订单即将过期，所以我们在没有收取额外费用的情况下帮你寄出去了！附上你的佣金。', UnitName("player"), info.recipeName, info.customerName or "")
            end
        end

        if (OpenMailFrame.itemButtonCount and OpenMailFrame.itemButtonCount > 0 ) then
            OpenMailAttachmentText:SetText('|cnGREEN_FONT_COLOR:拿取附件：')
        else
            OpenMailAttachmentText:SetText('无附件')
        end
        if InboxItemCanDelete(InboxFrame.openMailID) then
            OpenMailDeleteButton:SetText('删除')
        else
            OpenMailDeleteButton:SetText('退信')
        end
        OpenMailFrameTitleText:SetText('打开邮件')
    end)
    OpenMailReplyButton:SetText('回复')
    OpenMailCancelButton:SetText('关闭')
OpenMailInvoiceSalePrice:SetText('售价：')
OpenMailInvoiceDeposit:SetText('保证金：')
OpenMailInvoiceHouseCut:SetText('拍卖费：')
OpenMailInvoiceNotYetSent:SetText('未发送的数量')

OpenMailReportSpamButton:SetText('举报玩家')
ConsortiumMailFrame.CommissionReceived:SetText('附上佣金：')
ConsortiumMailFrame.CommissionPaidDisplay.CommissionPaidText:SetText('已支付佣金：')


