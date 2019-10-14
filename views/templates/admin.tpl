{*
* 2007-2015 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author     PAYCOMET <info@paycomet.com>
*  @copyright  2019 PAYTPV ON LINE ENTIDAD DE PAGO S.L
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*}

    

    <img width="200" src="{$base_dir|escape:'htmlall':'UTF-8':FALSE}modules/paytpv/views/img/paytpv.png" style="float:left; margin-right:15px;"><b>{l s='This module allows you to accept card payments via www.paycomet.com.' mod='paytpv'}</b><br /><br />
            {l s='If the customer chooses this payment method, they will be able to make payments automatically.' mod='paytpv'}<br /><br />

    {$errorMessage|escape:'quotes'}

    <div>
        <p><H1>{l s='PRERREQUISTES' mod='paytpv'}</H1></p>
            <ul>
                <li>{l s='PAYCOMET Account.' mod='paytpv'} {l s='You can request a Test account at: ' mod='paytpv'} <a href="mailto:info@paycomet.com">info@paycomet.com</a></li>
                <li>{l s='The store must be installed on-line, NOT in Local in order to use this module' mod='paytpv'}</li>
                <li>{l s='The PAYCOMET server must be accessible. (check that there are no problems when there is a firewall)' mod='paytpv'}</li>
            </ul>
        </p>
    </div>
    <form action="{$serverRequestUri|escape:'htmlall':'UTF-8':FALSE}" method="post">
    	<fieldset>    		
            <p>{l s='Please complete the information requested. You can obtain information on the PAYCOMET product.' mod='paytpv'}</p>

            
            <fieldset id="">
                <legend>{l s='PAYCOMET' mod='paytpv'}</legend>                 

                <label>{l s='Integration' mod='paytpv'}</label>
                <div class="margin-form">
                    <select name="integration" id="integration" onchange="checkmode();">
                        <option value="0" {if $integration==0}selected="1"{/if}>Bankstore IFRAME/XML</option>
                    </select>                    
                </div>

                <label>{l s='Client Code' mod='paytpv'}</label>
                <div class="margin-form"><input type="text" size="60" name="clientcode" value="{$clientcode|escape:'htmlall':'UTF-8':FALSE}" /></div>
        		
              
            </fieldset>

            <br/>
                
            <fieldset>
                <legend>{l s='Terminals' mod='paytpv'}&nbsp;<a id="addterminal" href="javascript:void(0)"><img onClick='addTerminal()' src="../img/admin/add.gif" title="{l s='Add Terminal' mod='paytpv'}" /></a></legend>
                {$cont=0}
                <ol id="terminales_disponibles">
                {foreach $terminales_paytpv as $terminal}
                <li id="terminal" class="terminal">
                    <fieldset>
                        <legend><a style="{if $cont==0}display:none{/if}"  href="javascript:void(0)" onclick="removeTerminal(this)"><img src="../img/admin/cross.png" title="{l s='Remove Terminal' mod='paytpv'}" /></a>
                        
                        {if $cont==0}
                        <img id="img_term_{$cont|escape:'htmlall':'UTF-8':FALSE}" src="../img/admin/bullet_green.png" title="" />
                        {/if}</legend>

                        <fieldset id="term_s_container_{$cont|escape:'htmlall':'UTF-8':FALSE}">
                            <legend>3D SECURE</legend>

                            <label>{l s='Terminal Number' mod='paytpv'}</label>
                            <div class="margin-form"><input type="text" size="8" class="term" maxlength="6" name="term[]" value="{$terminal['idterminal']|escape:'htmlall':'UTF-8':FALSE}" /></div>

                            <label>{l s='User Password' mod='paytpv'}</label>
                            <div class="margin-form"><input type="text" size="22" maxlength="30" name="pass[]" value="{$terminal['password']|escape:'htmlall':'UTF-8':FALSE}" /></div>

                            <div class="class_jetid">
                                <label>JET ID</label>
                                <div class="margin-form"><input type="text" size="40" maxlength="32" name="jetid[]" value="{$terminal['jetid']|escape:'htmlall':'UTF-8':FALSE}" /></div>
                            </div>
                        </fieldset>

                        <fieldset id="term_ns_container_{$cont|escape:'htmlall':'UTF-8':FALSE}">
                            <legend>NO 3D SECURE</legend>
                            <label>{l s='Terminal Number' mod='paytpv'}</label>
                            <div class="margin-form"><input type="text" size="8" name="term_ns[]" maxlength="6" value="{$terminal['idterminal_ns']|escape:'htmlall':'UTF-8':FALSE}" /></div>

                            <label>{l s='User Password' mod='paytpv'}</label>
                            <div class="margin-form"><input type="text" size="22" maxlength="30" name="pass_ns[]" value="{$terminal['password_ns']|escape:'htmlall':'UTF-8':FALSE}" /></div>

                            <div class="class_jetid">
                                <label>JET ID</label>
                                <div class="margin-form"><input type="text" maxlength="32" size="40" name="jetid_ns[]" value="{$terminal['jetid_ns']|escape:'htmlall':'UTF-8':FALSE}" /></div>
                            </div>
                        </fieldset>


                        <label>{l s='Terminals available' mod='paytpv'}</label>
                        <div class="margin-form"><select name="terminales[]" onchange="checkterminales(this);" id="terminales_{$cont|escape:'htmlall':'UTF-8':FALSE}" >
                            <option value="0" {if $terminal['terminales']==0} selected="1"{/if}>{l s='Secure' mod='paytpv'}</option>
                            <option value="1" {if $terminal['terminales']==1} selected="1"{/if}>{l s='Non-Secure' mod='paytpv'}</option>
                            <option value="2" {if $terminal['terminales']==2} selected="1"{/if}>{l s='Both' mod='paytpv'}</option>
                        </select></div>

                        <label>{l s='Use 3D Secure' mod='paytpv'}</label>
                        <div class="margin-form"><select name="tdfirst[]" onchange="checktdfirst(this);" id="tdfirst_{$cont|escape:'htmlall':'UTF-8':FALSE}">
                            <option value="0" {if $terminal['tdfirst']==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $terminal['tdfirst']==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select></div>

                        <label>{l s='Currency' mod='paytpv'}</label>
                        <div class="margin-form"><select name="moneda[]" id="moneda_{$cont|escape:'htmlall':'UTF-8':FALSE}">
                            {foreach from=$currency_array item=currency}
                            <option value="{$currency['iso_code']|escape:'htmlall':'UTF-8':FALSE}" {if $currency['iso_code']==$terminal['currency_iso_code']}selected="1"{/if}>{$currency['name']|escape:'htmlall':'UTF-8':FALSE} {if $currency['id_currency']==$default_currency} [{l s='Default Currency' mod='paytpv'}]{/if}</option>
                            {/foreach}
                        </select></div>

                        <div class="min3d" id="tdmin_container_{$cont|escape:'htmlall':'UTF-8':FALSE}">
                            <label>{l s='Use 3D Secure on purchases over' mod='paytpv'}</label>
                            <div class="margin-form"><input type="text" size="10" name="tdmin[]" width="10" id="tdmin_{$cont|escape:'htmlall':'UTF-8':FALSE}" value="{$terminal['tdmin']|escape:'htmlall':'UTF-8':FALSE}" style="text-align:right"/> [{l s='0 for Not use' mod='paytpv'}]</div>
                        </div>
                    </fieldset>
                </li>

                {$cont = $cont+1}

                {/foreach}
                
                
            </fieldset>
            

            <br/>
            <fieldset id="paytpv_options">
                <legend>{l s='Options' mod='paytpv'}</legend>
                <div id="commerce_password_container">
                    <label for="commerce_password_container" id="lblcommerce_password_container">{l s='Request business password on purchases with stored cards' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="commerce_password" id="commerce_password">
                            <option value="0" {if $commerce_password==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $commerce_password==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>
                    </div>
                </div>

                <br/>

                <div id="newpage_payment_container">
                    <label>{l s='Payment in new Page' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="newpage_payment" id="newpage_payment">
                            <option value="0" {if $newpage_payment==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $newpage_payment==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                            <option value="2" {if $newpage_payment==2}selected="1"{/if}>{l s='Yes. PAYTPV page' mod='paytpv'}</option>
                        </select>
                        [{l s='Yes for incompatible checkout modules' mod='paytpv'}]
                    </div>
                </div>

                <br/>

                <div id="disableoffersavecard">
                    <label>{l s='Disable Offer to save card' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="disableoffersavecard" id="disableoffersavecard">
                            <option value="0" {if $disableoffersavecard==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $disableoffersavecard==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>
                    </div>
                </div>

                <br/>

                <div id="remembercardunselected">
                    <label>{l s='Remember Card (Unselect)' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="remembercardunselected" id="remembercardunselected">
                            <option value="0" {if $remembercardunselected==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $remembercardunselected==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>
                    </div>
                </div>

                <br/>

                <div id="suscriptions_container">
                    <label>{l s='Activate Subscriptions' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="suscriptions" id="suscriptions">
                            <option value="0" {if $suscriptions==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $suscriptions==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>
                    </div>
                </div>

          

                
            </fieldset>




            <fieldset id="paytpv_scoring">
                <legend>{l s='Scoring' mod='paytpv'}</legend>
                <strong>{l s='IMPORTANT: If you want to activate the Scoring you should contact PAYCOMET' mod='paytpv'} </strong><br/><br/>
                
                <div class="scoring_calculation">{l s='Scoring calculation' mod='paytpv'}</div>

                <div id="merchantdata_container">
                    <label >{l s='First Purchase' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="firstpurchase_scoring" id="firstpurchase_scoring" onchange="changeScoring(this);">
                            <option value="0" {if $firstpurchase_scoring==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $firstpurchase_scoring==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>

                        <div style="padding-left: 15px; {if $firstpurchase_scoring==0}display:none;{/if}" class="firstpurchase_scoring_data inline">
                            <label style="float:none;">{l s='Score' mod='paytpv'}</label>
                            <select name="firstpurchase_scoring_score" id="firstpurchase_scoring_score">
                                {$i=0}
                                {while $i <= 100}
                                 <option value="{$i|escape:'htmlall':'UTF-8':FALSE}" {if $firstpurchase_scoring_score==$i}selected="1"{/if}>{$i|escape:'htmlall':'UTF-8':FALSE}</option>
                                  {$i++|escape:'htmlall':'UTF-8':FALSE}
                                {/while}
                            </select>
                        </div>
                    </div>

                </div>

                <div id="merchantdata_container">
                    <label>{l s='Complete Session Time' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="sessiontime_scoring" id="sessiontime_scoring" onchange="changeScoring(this);">
                            <option value="0" {if $sessiontime_scoring==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $sessiontime_scoring==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>

                        <div style="padding-left: 15px;{if $sessiontime_scoring==0}display:none;{/if}" class="sessiontime_scoring_data inline">
                            <label style="float:none;">{l s='Score' mod='paytpv'}</label>
                            <select name="sessiontime_scoring_score" id="firstpurchase_scoring_score">
                                {$i=0}
                                {while $i <= 100}
                                 <option value="{$i|escape:'htmlall':'UTF-8':FALSE}" {if $sessiontime_scoring_score==$i}selected="1"{/if}>{$i|escape:'htmlall':'UTF-8':FALSE}</option>
                                  {$i++|escape:'htmlall':'UTF-8':FALSE}
                                {/while}
                            </select>
                        </div>

                        <div style="padding-left: 15px;{if $sessiontime_scoring==0}display:none;{/if}" class="sessiontime_scoring_data inline">
                            <label style="float:none;">{l s='Time (hh:mm)' mod='paytpv'}  ></label>
                            <select name="sessiontime_scoring_val" id="sessiontime_scoring_val">
                                {assign var=arrTiempos value=['0'=>'00:00','15'=>'00:15','30'=>'00:30','45'=>'00:45','60'=>'01:00','90'=>'01:30','120'=>'02:00','180'=>'03:00','240'=>'04:00','300'=>'05:00','360'=>'06:00']}    

                                {foreach from=$arrTiempos key=key item=tiempo}
                                    <option value="{$key|escape:'htmlall':'UTF-8':FALSE}" {if $sessiontime_scoring_val==$key}selected="1"{/if}>{$tiempo|escape:'htmlall':'UTF-8':FALSE}</option>
                                {/foreach}
                                
                            </select>
                        </div>
                    </div>

                </div>

                <div id="merchantdata_container">
                    <label>{l s='Destination Country' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="dcountry_scoring" style="vertical-align:top;" id="dcountry_scoring" onchange="changeScoring(this);">
                            <option value="0" {if $dcountry_scoring==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $dcountry_scoring==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>

                        <div style="padding-left: 15px;{if $dcountry_scoring==0}display:none;{/if}" class="dcountry_scoring_data inline">
                            <label style="vertical-align:top;float:none;">{l s='Score' mod='paytpv'}</label>
                            <select name="dcountry_scoring_score" style="vertical-align:top;" id="dcountry_scoring_score">
                                {$i=0}
                                {while $i <= 100}
                                 <option value="{$i|escape:'htmlall':'UTF-8':FALSE}" {if $dcountry_scoring_score==$i}selected="1"{/if}>{$i|escape:'htmlall':'UTF-8':FALSE}</option>
                                  {$i++|escape:'htmlall':'UTF-8':FALSE}
                                {/while}
                            </select>
                        </div>

                        <div style="padding-left: 15px;{if $dcountry_scoring==0}display:none;{/if}" class="dcountry_scoring_data inline">
                            <label style="float:none;vertical-align:top;">{l s='Countries' mod='paytpv'}</label>
                            <select name="dcountry_scoring_val[]" id="dcountry_scoring_val" multiple="multiple" size="10">
                                {foreach from=$countries key=key item=countrie}
                                    <option value="{$countrie.iso_code|escape:'htmlall':'UTF-8':FALSE}" {if in_array($countrie.iso_code,$arr_dcountry_scoring_val)}selected="1"{/if}>{$countrie.name|escape:'htmlall':'UTF-8':FALSE}</option>
                                {/foreach}
                                
                            </select>
                        </div>
                    </div>

                </div>

                <div id="merchantdata_container">
                    <label >{l s='IP Change' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="ip_change_scoring" id="ip_change_scoring" onchange="changeScoring(this);">
                            <option value="0" {if $ip_change_scoring==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $ip_change_scoring==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>

                        <div style="padding-left: 15px;{if $ip_change_scoring==0}display:none;{/if}" class="ip_change_scoring_data inline">
                            <label style="float:none;">{l s='Score' mod='paytpv'}</label>
                            <select name="ip_change_scoring_score" id="ip_change_scoring_score">
                                {$i=0}
                                {while $i <= 100}
                                 <option value="{$i|escape:'htmlall':'UTF-8':FALSE}" {if $ip_change_scoring_score==$i}selected="1"{/if}>{$i|escape:'htmlall':'UTF-8':FALSE}</option>
                                  {$i++|escape:'htmlall':'UTF-8':FALSE}
                                {/while}
                            </select>
                        </div>
                    </div>

                </div>


                <div id="merchantdata_container">
                    <label >{l s='Browser Unidentified' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="browser_scoring" id="browser_scoring" onchange="changeScoring(this);">
                            <option value="0" {if $browser_scoring==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $browser_scoring==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>

                        <div style="padding-left: 15px;{if $browser_scoring==0}display:none;{/if}" class="browser_scoring_data inline">
                            <label style="float:none;">{l s='Score' mod='paytpv'}</label>
                            <select name="browser_scoring_score" id="browser_scoring_score">
                                {$i=0}
                                {while $i <= 100}
                                 <option value="{$i|escape:'htmlall':'UTF-8':FALSE}" {if $browser_scoring_score==$i}selected="1"{/if}>{$i|escape:'htmlall':'UTF-8':FALSE}</option>
                                  {$i++|escape:'htmlall':'UTF-8':FALSE}
                                {/while}
                            </select>
                        </div>
                    </div>

                </div>

                <div id="merchantdata_container">
                    <label >{l s='Operating System Unidentified' mod='paytpv'}</label>
                    <div class="margin-form">
                        <select name="so_scoring" id="so_scoring" onchange="changeScoring(this);">
                            <option value="0" {if $so_scoring==0}selected="1"{/if}>{l s='No' mod='paytpv'}</option>
                            <option value="1" {if $so_scoring==1}selected="1"{/if}>{l s='Yes' mod='paytpv'}</option>
                        </select>

                        <div style="padding-left: 15px;{if $so_scoring==0}display:none;{/if}" class="so_scoring_data inline">
                            <label style="float:none;">{l s='Score' mod='paytpv'}</label>
                            <select name="so_scoring_score" id="ip_change_scoring_score">
                                {$i=0}
                                {while $i <= 100}
                                 <option value="{$i|escape:'htmlall':'UTF-8':FALSE}" {if $so_scoring_score==$i}selected="1"{/if}>{$i|escape:'htmlall':'UTF-8':FALSE}</option>
                                  {$i++|escape:'htmlall':'UTF-8':FALSE}
                                {/while}
                            </select>
                        </div>
                    </div>

                </div>



                
                
            </fieldset>
    	</fieldset>	

        <br/>

        <fieldset style="display:none">
            <legend><img src="../img/admin/AdminPreferences.gif" />{l s='Customization' mod='paytpv'}</legend>  
            {l s='Please complete the additional data.' mod='paytpv'}
            <div class="margin-form"><p class="clear"></p></div>
            <label>{l s='Enable logging of failed / incomplete transactions' mod='paytpv'}</label>
            <div class="margin-form">
                <input type="radio" name="reg_estado" id="reg_estado_si" value="1" {if $reg_estado==1}checked="checked"{/if}/>
                <img src="../img/admin/enabled.gif" alt="{l s='Enabled' mod='paytpv'}" title="{l s='Enabled' mod='paytpv'}" />
                <input type="radio" name="reg_estado" id="reg_estado_no" value="0" {if $reg_estado!=1}checked="checked"{/if}/>
                <img src="../img/admin/disabled.gif" alt="{l s='Disabled' mod='paytpv'}" title="{l s='Disabled' mod='paytpv'}" />
                <p class="clear"></p>
            </div>
        </fieldset>

        <br/>
    
    	<center><input type="submit" id="btnSubmit" class="button" name="btnSubmit" value="{l s='Save Configuration' mod='paytpv' mod='paytpv'}" /></center>

    	<div>
            <p class="important">{l s='IMPORTANT' mod='paytpv'}</p>
    		<p><strong>{l s='Finally you need to configure in your account' mod='paytpv'} <a class='link' target="_blank" href="https://dashboard.paycomet.com/cp_control"> PAYCOMET </a>{l s='the following URLs for the payment module to work properly' mod='paytpv'}:</strong>
            </p>
			<ul class="paytpv">				
                <li><strong>{l s='Type of Notification (IMPORTANT)' mod='paytpv'}:</strong> {l s='Notification via URL or Notification via URL and email' mod='paytpv'}
                    <ul class="paytpv">
                        <li><strong>URL NOTIFICACION:</strong> {$NOTIFICACION|escape:'htmlall':'UTF-8':FALSE}</li>
                    </ul>
                </li>		
			</ul>

    	</div>

        <div>
            <p class="important">{l s='USER DOCUMENTATION' mod='paytpv'}</p>
            <p><strong>{l s='Link to documentation by clicking the following link' mod='paytpv'} <a class='link' target="_blank"  href="https://docs.paycomet.com/es/modulos-de-pago/prestashop">{l s='USER DOCUMENTATION'  mod='paytpv'}</a></strong>
        </div>

    </form>

    {if $reg_estado==1}

    <br /><br /><br />

    <form action="'.$_SERVER['REQUEST_URI'].'" method="post">
        <fieldset>
            <legend><img src="../img/admin/contact.gif" alt="" title="" />{l s='Failed Transactions' mod='paytpv'}</legend>
            <table class="table">
                <thead>
                    <tr>
                        <th class="item" style="text-align:center;width:150px;">{l s='Date' mod='paytpv'}</th>
                        <th class="item" style="width:325px;">{l s='Client' mod='paytpv'}</th>
                        <th class="item" style="text-align:center;width:75px;">{l s='Amount' mod='paytpv'}</th>
                        <th class="item" style="text-align:center;width:300px;">{l s='Error type' mod='paytpv'}</th>
                        <th class="item" style="text-align:center;width:50px;">{l s='Actions' mod='paytpv'}</th>
                    </tr>
                </thead>
                <tbody>
                {foreach from=$carritos item=registro}
                    <tr>
                        <td class="first_item" style="text-align:center;">{$registro['date_add']|escape:'htmlall':'UTF-8':FALSE}</td>
                        <td class="item" style="text-align:left;"><span>{$registro['customer_firstname']|escape:'htmlall':'UTF-8':FALSE} {$registro['customer_lastname']|escape:'htmlall':'UTF-8':FALSE}</span></td>
                        <td class="item" style="text-align:center;">{$registro['amount']|escape:'htmlall':'UTF-8':FALSE}</td>
                        <td class="item" style="text-align:left;">{$registro['error_code']|escape:'htmlall':'UTF-8':FALSE}</td>
                        <td class="center">
                            <img onClick="document.location ={$currentindex|escape:'htmlall':'UTF-8':FALSE}&configure={$name|escape:'htmlall':'UTF-8':FALSE}&token={$token|escape:'htmlall':'UTF-8':FALSE}&amount={$registro['amount']|escape:'htmlall':'UTF-8':FALSE}&id_cart={$registro['id_cart']|escape:'htmlall':'UTF-8':FALSE}&id_registro={$registro['id_registro']|escape:'htmlall':'UTF-8':FALSE}';" src="../img/admin/add.gif" style="cursor:pointer" alt="{l s='Create Order' mod='paytpv'}" title="{l s='Create Order' mod='paytpv'}" />
                            
                            <img onClick="if (confirm(\"{l s='Delete this payment error?' mod='paytpv'}\")) document.location = {$currentindex|escape:'htmlall':'UTF-8':FALSE}&configure={$name|escape:'htmlall':'UTF-8':FALSE}&token={$token|escape:'htmlall':'UTF-8':FALSE}&id_registro={$registro['id_registro']|escape:'htmlall':'UTF-8':FALSE}';" style="cursor:pointer; margin-left:10px;" src="../img/admin/disabled.gif" alt="{l s='Remove record' mod='paytpv'}" title="{l s='Remove record' mod='paytpv'}" />
                        </td>
                    </tr>
                {/foreach}
                </tbody>
                </table>
                </fieldset>    
        {/if}	

    </form>

    <script>
        
        function checkAllTerminales(){
           
            // Real Mode
            for(i=0;i<jQuery(".term").length;i++){
                checkterminales($("#terminales_"+i));
            }
        }
        
        function checkterminales(element){
           
            cont = $(element).attr('id').replace('terminales_','');

            // Si solo tiene terminal seguro o tiene los dos la primera compra va por seguro
            // Seguro
            switch (jQuery("#terminales_"+cont).val()){
                case "0": // SEGURO
                    jQuery("#tdfirst_"+cont).val(1);
                    jQuery("#tdmin_container_"+cont).hide();
                    jQuery("#term_s_container_"+cont).show();
                    jQuery("#term_ns_container_"+cont).hide();
                    break;
                case "1": // NO SEGURO
                    jQuery("#tdfirst_"+cont).val(0);
                    jQuery("#tdmin_container_"+cont).hide();
                    jQuery("#term_s_container_"+cont).hide();
                    jQuery("#term_ns_container_"+cont).show();
                    break;
                case "2": // AMBOS
                    jQuery("#tdmin_container_"+cont).show();
                    jQuery("#term_s_container_"+cont).show();
                    jQuery("#term_ns_container_"+cont).show();
                    break;
            }
        }

        function checktdfirst(element){
            cont = $(element).attr('id').replace('tdfirst_','');
            
            // Si solo tiene terminal seguro la primera compra va por seguro
            if(jQuery("#terminales_"+cont).val() == 0 && jQuery("#tdfirst_"+cont).val()==0){
                alert("{l s='If you only have a Secure terminal, payments always go via Secure' mod='paytpv'}");
                jQuery("#tdfirst_"+cont).val(1);
            }
            // Si solo tiene terminal no seguro la primera compra va por seguro
            if(jQuery("#terminales_"+cont).val() == 1 && jQuery("#tdfirst_"+cont).val()==1){
                alert("{l s='If you only have a Non-Secure terminal, payments always go via Non-Secure' mod='paytpv'}");
                jQuery("#tdfirst_"+cont).val(0);
            }
        }

                
        
        checkAllTerminales();
        checkaddTerminal();
        checkmode();


        function addTerminal(){

            cont = jQuery(".term").length;

            var $term = jQuery("#terminal").clone()
                    .find("input").val("").end()
                    .find("select").val("").end()
                    .find("#img_term_0").remove().end()
                    .find("#moneda_0").attr("id","moneda_"+cont).end()
                    .find("#terminales_0").attr("id","terminales_"+cont).end()
                    .find("#tdfirst_0").attr("id","tdfirst_"+cont).end()
                    .find("#tdmin_container_0").attr("id","tdmin_container_"+cont).end()
                    .find("#term_s_container_0").attr("id","terms_s_container_"+cont).end()
                    .find("#term_ns_container_0").attr("id","term_ns_container_"+cont).end()
                    .find("#tdmin_0").attr("id","tdmin_"+cont).end()
                    .find("a").show().end()
                    .appendTo("#terminales_disponibles");

            jQuery("#terminales_"+cont).val(0);
            jQuery("#tdfirst_"+cont).val(1);
            jQuery("#moneda_"+cont+" option:first").attr('selected','selected');
            checkterminales($("#terminales_"+cont));
            checkaddTerminal();

        }

        function removeTerminal(el){
            if (confirm("{l s='Are you sure?' mod='paytpv'}")){
                
                jQuery(el).closest('li').remove();

                checkaddTerminal();
               
            }
        }

        function checkaddTerminal(){
            if (jQuery(".term").length<jQuery("#moneda_0").find("option").size())
                jQuery("#addterminal").show()
            else
                jQuery("#addterminal").hide()

        }

        function checkmode(){
            if (jQuery("#integration").val()==0){
                jQuery(".class_jetid").hide();
                
            }else{
                jQuery(".class_jetid").show();
            }

        }

        function changeScoring(select){
           
            if (select.value==1)
                jQuery("." + select.id + "_data").show();
            else
                jQuery("." + select.id + "_data").hide();

        }

    </script>

