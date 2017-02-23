<?php
/*
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
*  @author     Jose Ramon Garcia <jrgarcia@paytpv.com>
*  @copyright  2015 PAYTPV ON LINE S.L.
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*/
/**
 * @since 1.5.0
 */

include_once(_PS_MODULE_DIR_.'/paytpv/ws_client.php');
class PaytpvCaptureModuleFrontController extends ModuleFrontController
{
    public $display_column_left = false;
    public $ssl = true;
   
    /**
     * @see FrontController::initContent()
     */
   	public function initContent()
    {

    	parent::initContent();
    	
        $this->context->smarty->assign(array(
            'this_path' => Tools::getShopDomainSsl(true, true).__PS_BASE_URI__.'modules/'.$this->module->name.'/'
        ));  

		$paytpv = $this->module;


		$password_fail = 0;
		$error_msg = "";
		// Verificar contraseña usuario.
		if ($paytpv->commerce_password){
	        if (!$paytpv->validPassword($this->context->cart->id_customer,Tools::getValue('password'))){
	        	$password_fail = 1;
	        	$this->context->smarty->assign('password_fail',$password_fail);
	        	$this->context->smarty->assign('error_msg',$error_msg);
	        	$this->setTemplate('payment_fail.tpl');
	        	
	        	return;
	        }
	    }
	    $id_currency = intval(Configuration::get('PS_CURRENCY_DEFAULT'));
		$currency = new Currency(intval($id_currency));
		$total_pedido = $this->context->cart->getOrderTotal(true, Cart::BOTH);
		
		$datos_pedido = $paytpv->TerminalCurrency($this->context->cart);
		$importe = $datos_pedido["importe"];
		$currency_iso_code = $datos_pedido["currency_iso_code"];
		$idterminal = $datos_pedido["idterminal"];
		$pass = $datos_pedido["password"];
		$jetid = $datos_pedido["jetid"];

	    // BANKSTORE JET
	    $token = isset($_POST["paytpvToken"])?$_POST["paytpvToken"]:"";
	    $savecard_jet = isset($_POST["savecard_jet"])?$_POST["savecard_jet"]:0;

	   
	    $jetPayment = 0;
	    if ($token && strlen($token) == 64){

	    	$client = new WS_Client(
				array(
					'clientcode' => $paytpv->clientcode,
					'term' => $idterminal,
					'pass' => $pass,
					'jetid' => $jetid
				)
			);

			$addUserResponse = $client->add_user_token($token);
			if ( ( int ) $addUserResponse[ 'DS_ERROR_ID' ] > 0 ) {
				$this->context->smarty->assign('error_msg',$paytpv->l('Cannot operate with given credit card','capture'));
				$this->context->smarty->assign('password_fail',$password_fail);

        		$this->setTemplate('payment_fail.tpl');
        		return;

			}else{
				$data["IDUSER"] = $addUserResponse["DS_IDUSER"];
				$data["TOKEN_USER"] = $addUserResponse["DS_TOKEN_USER"];

				$jetPayment = 1;
			}
		// TOKENIZED CARD
		}else{
        	$data = Paytpv_Customer::get_Card_Token_Customer($_GET["TOKEN_USER"],$this->context->cart->id_customer);
        	if (!isset($data["IDUSER"])){
	        	$this->context->smarty->assign('base_dir',__PS_BASE_URI__);
	        	$this->setTemplate('payment_fail.tpl');
	        	return;
        	}
        	Paytpv_Order_Info::save_Order_Info((int)$this->context->customer->id,$this->context->cart->id,0,0,0,0,$data["IDUSER"]);
        }
		
		// Si el cliente solo tiene un terminal seguro, el segundo pago va siempre por seguro.
		// Si tiene un terminal NO Seguro ó ambos, el segundo pago siempre lo mandamos por NO Seguro
		

		// PAGO SEGURO

		$secure_pay = $paytpv->isSecureTransaction($idterminal,$total_pedido,$data["IDUSER"])?1:0;

		if ($secure_pay){

			$paytpv_order_ref = str_pad($this->context->cart->id, 8, "0", STR_PAD_LEFT);

			$values = array(
				'id_cart' => (int)$this->context->cart->id,
				'key' => Context::getContext()->customer->secure_key
			);
			$ssl = Configuration::get('PS_SSL_ENABLED');
			
			$URLOK=Context::getContext()->link->getModuleLink($paytpv->name, 'urlok',$values,$ssl);
			$URLKO=Context::getContext()->link->getModuleLink($paytpv->name, 'urlko',$values,$ssl);

			if ($jetPayment && $_POST["suscription"]==1){
				$subscription_startdate = date("Ymd");
				$susc_periodicity = $_POST["periodicity"];
				$subs_cycles = $_POST["cycles"];

				// Si es indefinido, ponemos como fecha tope la fecha + 10 años.
				if ($subs_cycles==0)
					$subscription_enddate = date("Y")+5 . date("m") . date("d");
				else{
					// Dias suscripcion
					$dias_subscription = $subs_cycles * $susc_periodicity;
					$subscription_enddate = date('Ymd', strtotime("+".$dias_subscription." days"));
				}
				$OPERATION = "110";
				$signature = md5($paytpv->clientcode.$data["IDUSER"].$data['TOKEN_USER'].$idterminal.$OPERATION.$paytpv_order_ref.$importe.$currency_iso_code.md5($pass));
				$fields = array
				(
					'MERCHANT_MERCHANTCODE' => $paytpv->clientcode,
					'MERCHANT_TERMINAL' => $idterminal,
					'OPERATION' => $OPERATION,
					'LANGUAGE' => $this->context->language->iso_code,
					'MERCHANT_MERCHANTSIGNATURE' => $signature,
					'MERCHANT_ORDER' => $paytpv_order_ref,
					'MERCHANT_AMOUNT' => $importe,
					'MERCHANT_CURRENCY' => $currency_iso_code,
					'SUBSCRIPTION_STARTDATE' => $subscription_startdate, 
					'SUBSCRIPTION_ENDDATE' => $subscription_enddate,
					'SUBSCRIPTION_PERIODICITY' => $susc_periodicity,
					'IDUSER' => $data["IDUSER"],
					'TOKEN_USER' => $data['TOKEN_USER'],
					'URLOK' => $URLOK,
					'URLKO' => $URLKO,
					'3DSECURE' => $secure_pay
				);
			}else{

				$OPERATION = "109"; //exec_purchase_token
				$signature = md5($paytpv->clientcode.$data["IDUSER"].$data['TOKEN_USER'].$idterminal.$OPERATION.$paytpv_order_ref.$importe.$currency_iso_code.md5($pass));
		
				$fields = array
					(
						'MERCHANT_MERCHANTCODE' => $paytpv->clientcode,
						'MERCHANT_TERMINAL' => $idterminal,
						'OPERATION' => $OPERATION,
						'LANGUAGE' => $this->context->language->iso_code,
						'MERCHANT_MERCHANTSIGNATURE' => $signature,
						'MERCHANT_ORDER' => $paytpv_order_ref,
						'MERCHANT_AMOUNT' => $importe,
						'MERCHANT_CURRENCY' => $currency_iso_code,
						'IDUSER' => $data["IDUSER"],
						'TOKEN_USER' => $data['TOKEN_USER'],
						'3DSECURE' => $secure_pay,
						'URLOK' => $URLOK,
						'URLKO' => $URLKO
					);
			}
				
			$query = http_build_query($fields);

			if ($paytpv->environment!=1)
				$salida = $paytpv->url_paytpv . "?".$query;
			// Test Mode
			else
				$salida = Context::getContext()->link->getModuleLink($paytpv->name, 'url3dstest',$fields,$ssl);

			header('Location: '.$salida);
			exit;
		}
		/* FIN AÑADIDO */
		
		$client = new WS_Client(
			array(
				'clientcode' => $paytpv->clientcode,
				'term' => $idterminal,
				'pass' => $pass,
			)
		);
		$paytpv_order_ref = str_pad($this->context->cart->id, 8, "0", STR_PAD_LEFT);
		// Test Mode
		if ($paytpv->environment==1){
			$transaction = array(
				'transaction_id' => "Test_mode",
				'result' => 0
			);
			$pagoRegistrado = $paytpv->validateOrder(Context::getContext()->cart->id, _PS_OS_PAYMENT_, $total_pedido, $paytpv->displayName, NULL, $transaction, NULL, false, Context::getContext()->customer->secure_key);
			$id_order = Order::getOrderByCartId(intval(Context::getContext()->cart->id));
			Paytpv_Order::add_Order($data["IDUSER"],$data['TOKEN_USER'],0,Context::getContext()->cart->id_customer,$id_order,$total_pedido);
			$charge['DS_RESPONSE'] =1;

		}else{


			if ($jetPayment && (isset($_POST["suscription"]) && $_POST["suscription"]==1)){
				$subscription_startdate = date("Y-m-d");
				$susc_periodicity = $_POST["periodicity"];
				$subs_cycles = $_POST["cycles"];

				// Si es indefinido, ponemos como fecha tope la fecha + 10 años.
				if ($subs_cycles==0)
					$subscription_enddate = date("Y")+5 . "-" . date("m") . "-" . date("d");
				else{
					// Dias suscripcion
					$dias_subscription = $subs_cycles * $susc_periodicity;
					$subscription_enddate = date('Y-m-d', strtotime("+".$dias_subscription." days"));
				}
				
				$charge = $client->create_subscription_token( $data['IDUSER'],$data['TOKEN_USER'],$currency_iso_code,$importe,$paytpv_order_ref,$subscription_startdate,$subscription_enddate,$susc_periodicity);
			}else{
				$charge = $client->execute_purchase( $data['IDUSER'],$data['TOKEN_USER'],$idterminal,$currency_iso_code,$importe,$paytpv_order_ref);
			}
		}
		if ( (isset($charge[ 'DS_RESPONSE' ]) && ( int )$charge[ 'DS_RESPONSE' ] == 1) || $charge[ 'DS_ERROR_ID' ] == 0) {

			if ($jetPayment && $savecard_jet==1){
				$result = $client->info_user( $data['IDUSER'],$data['TOKEN_USER']);
				$result = $paytpv->saveCard($this->context->cart->id_customer,$data['IDUSER'],$data['TOKEN_USER'],$result['DS_MERCHANT_PAN'],$result['DS_CARD_BRAND']);
				
			}
			//Esperamos a que la notificación genere el pedido
			sleep ( 3 );
			$id_order = Order::getOrderByCartId(intval($this->context->cart->id));
			$values = array(
				'id_cart' => $this->context->cart->id,
				'id_module' => (int)$this->module->id,
				'id_order' => $id_order,
				'key' => $this->context->customer->secure_key
			);
			Tools::redirect(Context::getContext()->link->getPageLink('order-confirmation',$this->ssl,null,$values));
			return;
		}else{

			if (isset($reg_estado) && $reg_estado == 1)
			//se anota el pedido como no pagado
			class_registro::add($this->context->cart->id_customer, $this->context->cart->id, $importe, $charge[ 'DS_RESPONSE' ]);
		}
				
		$this->context->smarty->assign('error_msg',$paytpv->l('Cannot operate with given credit card','capture'));
		$this->context->smarty->assign('password_fail',$password_fail);	
		$this->context->smarty->assign('base_dir',__PS_BASE_URI__);
        $this->setTemplate('payment_fail.tpl');
        return;

    }

}

